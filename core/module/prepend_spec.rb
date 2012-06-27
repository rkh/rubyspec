require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Module#prepend" do
    it "calls #prepend_features(self) in reversed order on each module" do
      $prepended_modules = []

      m = Module.new do
        def self.prepend_features(mod)
          $prepended_modules << [ self, mod ]
        end
      end

      m2 = Module.new do
        def self.prepend_features(mod)
          $prepended_modules << [ self, mod ]
        end
      end

      m3 = Module.new do
        def self.prepend_features(mod)
          $prepended_modules << [ self, mod ]
        end
      end

      c = Class.new { prepend(m, m2, m3) }

      $prepended_modules.should == [ [ m3, c], [ m2, c ], [ m, c ] ]
    end

    it "raises a TypeError when the argument is not a Module" do
      lambda { ModuleSpecs::Basic.send(:prepend, Class.new) }.should raise_error(TypeError)
    end

    it "does not raise a TypeError when the argument is an instance of a subclass of Module" do
      lambda { ModuleSpecs::SubclassSpec.send(:prepend, ModuleSpecs::Subclass.new) }.should_not raise_error(TypeError)
    end

    it "does not import constants" do
      m1 = Module.new { A = 1 }
      m2 = Module.new { prepend(m1) }
      m1.constants.should_not include(:A)
    end

    it "imports instance methods" do
      Module.new { prepend ModuleSpecs::A }.instance_methods.should include(:ma)
    end

    it "does not import methods to modules and classes" do
      Module.new { prepend ModuleSpecs::A }.methods.should_not include(:ma)
    end

    it "allows wrapping methods" do
      m = Module.new { def calc(x) super + 3 end }
      c = Class.new { def calc(x) x*2 end }
      c.send(:prepend, m)
      c.new.calc(1).should == 5
    end

    it "also prepends included modules" do
      a = Module.new { def calc(x) x end }
      b = Module.new { include a }
      c = Class.new { prepend b }
      c.new.calc(1).should == 1
    end

    it "includes prepended modules in ancestors" do
      m = Module.new
      Class.new { prepend(m) }.ancestors.should include(m)
    end

    it "depends on prepend_features to add the module" do
      m = Module.new { def self.prepend_features(mod) end }
      Class.new { prepend(m) }.ancestors.should_not include(m)
    end

    it "works with subclasses" do
      m = Module.new do
        def chain
          super << :module
        end
      end

      c = Class.new do
        prepend m
        def chain
          [:class]
        end
      end

      s = Class.new(c) do
        def chain
          super << :subclass
        end
      end

      s.new.chain.should == [:class, :module, :subclass]
    end

    it "calls prepended after prepend_features" do
      $prepend_calls = []

      m = Module.new do
        def self.prepend_features(klass)
          $prepend_calls << [:prepend_features, klass]
        end
        def self.prepended(klass)
          $prepend_calls << [:prepended, klass]
        end
      end

      c = Class.new { prepend(m) }
      $prepend_calls.should == [[:prepend_features, c], [:prepended, c]]
    end

    it "detects cyclic prepends" do
      lambda {
        module ModuleSpecs::P
          prepend ModuleSpecs::P
        end
      }.should raise_error(ArgumentError)
    end

    it "accepts no-arguments" do
      lambda {
        Module.new do
          prepend
        end
      }.should_not raise_error
    end

    it "returns the class it's included into" do
      m = Module.new
      r = nil
      c = Class.new { r = prepend m }
      r.should == c
    end

    it "clears any caches" do
      module ModuleSpecs::M3
        module PM1
          def foo
            :m1
          end
        end

        module PM2
          def foo
            :m2
          end
        end

        class PC
          prepend PM1

          def get
            foo
          end
        end

        c = PC.new
        c.get.should == :m1

        class PC
          prepend PM2
        end

        c.get.should == :m2
      end
    end
  end
end
