require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Module#append_features" do
    it "gets called when self is included in another module/class" do
      begin
        m = Module.new do
          def self.prepend_features(mod)
            $prepended_to = mod
          end
        end

        c = Class.new do
          prepend m
        end

        $prepended_to.should == c
      ensure
        $prepended_to = nil
      end
    end

    it "raises an ArgumentError on a cyclic prepend" do
      lambda {
        ModuleSpecs::CyclicPrepend.send(:prepend_features, ModuleSpecs::CyclicPrepend)
      }.should raise_error(ArgumentError)
    end
  end
end
