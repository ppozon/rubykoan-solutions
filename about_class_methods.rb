require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutClassMethods < Neo::Koan
  class Sharing
  end

  def test_objects_are_objects
    fido = Sharing.new
    assert_equal true, fido.is_a?(Object)
  end

  def test_classes_are_classes
    assert_equal true, Sharing.is_a?(Class)
  end

  def test_classes_are_objects_too
    assert_equal true, Sharing.is_a?(Object)
  end

  def test_objects_have_methods
    fido = Sharing.new
    size = fido.methods.size
    assert size > 58
  end

  def test_classes_have_methods
    size = Sharing.methods.size
#   puts "[ #{size} ] "
    assert Sharing.methods.size > 103
  end

  def test_you_can_define_methods_on_individual_objects
    fido = Sharing.new
    def fido.wag
      :fidos_wag
    end
    assert_equal :fidos_wag, fido.wag
  end

  def test_other_objects_are_not_affected_by_these_singleton_methods
    fido = Sharing.new
    rover = Sharing.new
    def fido.wag
      :fidos_wag
    end

    assert_raise(NoMethodError) do
      rover.wag
    end
  end

  # ------------------------------------------------------------------

  class Sharing2
    def wag
      :instance_level_wag
    end
  end

  def Sharing2.wag
    :class_level_wag
  end

  def test_since_classes_are_objects_you_can_define_singleton_methods_on_them_too
    assert_equal :class_level_wag, Sharing2.wag
  end

  def test_class_methods_are_independent_of_instance_methods
    fido = Sharing2.new
    assert_equal :instance_level_wag, fido.wag
    assert_equal :class_level_wag, Sharing2.wag
  end

  # ------------------------------------------------------------------

  class Sharing
    attr_accessor :name
  end

  def Sharing.name
    @name
  end

  def test_classes_and_instances_do_not_share_instance_variables
    fido = Sharing.new
    fido.name = "Fido"
    assert_equal "Fido", fido.name
    assert_equal nil, Sharing.name
  end

  # ------------------------------------------------------------------

  class Sharing
    def Sharing.a_class_method
      :dogs_class_method
    end
  end

  def test_you_can_define_class_methods_inside_the_class
    assert_equal :dogs_class_method, Sharing.a_class_method
  end

  # ------------------------------------------------------------------

  LastExpressionInClassStatement = class Sharing
                                     21
                                   end

  def test_class_statements_return_the_value_of_their_last_expression
    assert_equal 21, LastExpressionInClassStatement
  end

  # ------------------------------------------------------------------

  SelfInsideOfClassStatement = class Sharing
                                 self
                               end

  def test_self_while_inside_class_is_class_object_not_instance
    assert_equal true, Sharing == SelfInsideOfClassStatement
  end

  # ------------------------------------------------------------------

  class Sharing
    def self.class_method2
      :another_way_to_write_class_methods
    end
  end

  def test_heres_still_another_way_to_write_class_methods
    assert_equal :another_way_to_write_class_methods, Sharing.class_method2
  end

  # ------------------------------------------------------------------

  class Sharing
    class << self
      def another_class_method
        :still_another_way
      end
    end
  end

  def test_you_can_use_self_instead_of_an_explicit_reference_to_dog
    assert_equal :still_another_way, Sharing.another_class_method
  end

  # THINK ABOUT IT:
  #
  # The two major ways to write class methods are:
  #   class Demo
  #     def self.method
  #     end
  #
  #     class << self
  #       def class_methods
  #       end
  #     end
  #   end
  #
  # Which do you prefer and why?
  # Are there times you might prefer one over the other?
  # PPA the "<< self" method is less readable. But might be useful
  # if the class were defined dynamically.

  # ------------------------------------------------------------------

  def test_heres_an_easy_way_to_call_class_methods_from_instance_methods
    fido = Sharing.new
    assert_equal :still_another_way, fido.class.another_class_method
  end

end
