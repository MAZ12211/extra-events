import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;

class VignEffect extends FlxRuntimeShader {
  public var uIntensity:Float;

  public function new() {
    var fragText:String = Assets.getText(Paths.frag('ui/shaders/ee-vignette'));
    super(fragText);
  }

  function setIntensity(value:Float) {
    this.setFloat('u_intensity', value);
    return uIntensity = value;
  }

  function update(elapsed:Float) {
    setIntensity(uIntensity += elapsed);
  }
}
