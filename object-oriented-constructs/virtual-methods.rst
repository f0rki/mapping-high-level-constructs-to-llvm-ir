Virtual Methods
---------------

A virtual method is no more than a compiler-controlled function pointer.
Each virtual method is recorded in the ``vtable``, which is a structure
of all the function pointers needed by a given class:

.. code-block:: cpp

    class Foo
    {
    public:
        virtual int GetLengthTimesTwo() const
        {
            return _length * 2;
        }

        void SetLength(size_t value)
        {
            _length = value;
        }

    private:
        int _length;
    };

    int main()
    {
        Foo foo;
        foo.SetLength(4);
        return foo.GetLengthTimesTwo();
    }

This becomes:

.. code-block:: llvm

    %Foo_vtable_type = type { i32(%Foo*)* }

    %Foo = type { %Foo_vtable_type*, i32 }

    define i32 @Foo_GetLengthTimesTwo(%Foo* %this) nounwind {
        %1 = getelementptr %Foo, %Foo* %this, i32 0, i32 1
        %2 = load i32, i32* %1
        %3 = mul i32 %2, 2
        ret i32 %3
    }

    @Foo_vtable_data = global %Foo_vtable_type {
        i32(%Foo*)* @Foo_GetLengthTimesTwo
    }

    define void @Foo_Create_Default(%Foo* %this) nounwind {
        %1 = getelementptr %Foo, %Foo* %this, i32 0, i32 0
        store %Foo_vtable_type* @Foo_vtable_data, %Foo_vtable_type** %1
        %2 = getelementptr %Foo, %Foo* %this, i32 0, i32 1
        store i32 0, i32* %2
        ret void
    }

    define void @Foo_SetLength(%Foo* %this, i32 %value) nounwind {
        %1 = getelementptr %Foo, %Foo* %this, i32 0, i32 1
        store i32 %value, i32* %1
        ret void
    }

    define i32 @main(i32 %argc, i8** %argv) nounwind {
        %foo = alloca %Foo
        call void @Foo_Create_Default(%Foo* %foo)
        call void @Foo_SetLength(%Foo* %foo, i32 4)
        %1 = getelementptr %Foo, %Foo* %foo, i32 0, i32 0
        %2 = load %Foo_vtable_type*, %Foo_vtable_type** %1
        %3 = getelementptr %Foo_vtable_type, %Foo_vtable_type* %2, i32 0, i32 0
        %4 = load i32(%Foo*)*, i32(%Foo*)** %3
        %5 = call i32 %4(%Foo* %foo)
        ret i32 %5
    }

Please notice that some C++ compilers store ``_vtable`` at a negative
offset into the structure so that things like
``memset(this, 0, sizeof(*this))`` work, even though such commands
should always be avoided in an OOP context.


Rust Traits and VTables
~~~~~~~~~~~~~~~~~~~~~~~

Rust does have quite a different object model when compared to C++. However,
when it comes to the low-level details of dynamic dispatch, they are remarkably
similar. We'll explore an example from the `rust documentation <https://doc.rust-lang.org/book/ch17-02-trait-objects.html>`_ and what kind of
llvm IR is emitted by the rustc compiler.  Both rust and C++ utilizes virtual
method tables for dynamic dispatch. However, in rust there is no such thing as
virtual methods in the high-level language.  Instead we can implement traits
for our data types and then implement an interface that accepts all data types
that implement this trait and dynamically dispatch to the right trait
implementation (i.e., this is the ``dyn Trait`` syntax in the example below).
The full example is given here for easy reference:

.. literalinclude:: listings/rust-traits/test.rs
   :language: rust

Here the compiler must dynamically decide at runtime, which function to
execute. The compiler only knows that the object stored in the components
vector does satisfy the trait Draw. As a side note for those not so familiar
with rust: wrapping the object within a
``Box`` essentially puts the object on the heap (somewhat akin to a
``unique_ptr`` in C++) and effectively allows us to put trait objects (i.e.,
``dyn Drawable`` in this example) in a vector.


.. code-block:: llvm

    ; test::Screen::run
    ; Function Attrs: nonlazybind uwtable
    define void @"Screen::run"(%Screen* %self) {
    start:

    ;; (omitting the initial prologue and setup code)
    ;; this is the start of the for loop in Screen::run calling the next method
    ;; on the iterator for the first time and checking whether it is None (or
    ;; null in llvm here)
    ;; %5 contains the pointer to the first component in the vector here
      %6 = icmp eq i64* %5, null
      br i1 %6, label %end, label %forloop

    end:                                              ; preds = %forloop, %start
      ret void

    forloop:                                          ; preds = %start, %forloop
      %7 = phi i64* [ %next_component, %forloop ], [ %5, %start ]
    ;; here the boxed pointer is retrieved and dereferenced to retrieve the
    ;; vtable pointer
      %8 = bitcast i64* %7 to {}**
      %self_ptr = load {}*, {}** %8
      %9 = getelementptr inbounds i64, i64* %7, i64 1
      %vtable_ptr = bitcast i64* %9 to void ({}*)***
      %vtable = load void ({}*)**, void ({}*)*** %vtable_ptr
    ;; 3 is the index into the vtable struct, which refers to the draw implementation for this particular struct
      %trait_method_ptr = getelementptr inbounds void ({}*)*, void ({}*)** %vtable, i64 3
      %trait_method = load void ({}*)*, void ({}*)** %vmethod
    ;; indirect call to trait method
      call void %trait_method({}* %self_ptr)

    ;; retrieve the next object
      %next_component = call i64* @"<core::slice::iter::Iter<T> as core::iter::traits::iterator::Iterator>::next"({ i64*, i64* }* %iter)
      %14 = icmp eq i64* %next_component, null
      br i1 %14, label %end, label %forloop
    }


Within the global variables in the llvm module we can see the vtable as shown
here. Both the ``Button`` and the ``SelectBox`` have associated vtables.

.. code-block:: llvm

    @vtable.screen = private unnamed_addr constant 
      ;; the Type of the constant vtable structure
      { void (%SelectBox*)*, i64, i64, void (%SelectBox*)* } 
      { 
        ;; first entry is the function to drop the object
        void (%SelectBox*)* @"core::ptr::drop_in_place<test::SelectBox>",  ;; destructor
        i64 32, ;; size
        i64 8,  ;; alignment
        ;; last in the vtable is the pointer to the SelectBox::draw implementation
        void (%SelectBox*)* @"<test::SelectBox as test::Draw>::draw"
      }

    ;; the vtable for Button is structured basically the same
    @vtable.button = private unnamed_addr constant 
        { void (%Button*)*, i64, i64, void (%Button*)* } 
        { 
            void (%Button*)* @"core::ptr::drop_in_place<test::Button>", 
            i64 32, i64 8, 
            void (%Button*)* @"<test::Button as test::Draw>::draw"
        }

The older version of the rust book also features an excellent an concise `description of how vtables in rust work <https://doc.rust-lang.org/1.30.0/book/first-edition/trait-objects.html#representation>`_.
It seems that newer version follow the same pattern internally, although this
has been removed from the official rust book.

Finally, `here is a blogpost <https://alschwalm.com/blog/static/2017/03/07/exploring-dynamic-dispatch-in-rust/>`_ that explains vtables and dynamic dispatch and
their differences in rust vs C++ in some more detail.
