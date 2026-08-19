import funkin.play.PlayState;
import funkin.Conductor;
import flixel.FlxG;
import funkin.modding.PolymodErrorHandler;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.util.ReflectUtil;

import funkin.play.event.SongEvent;
import funkin.play.event.ScriptedSongEvent;

import funkin.modding.module.ModuleHandler;
import funkin.modding.module.ScriptedModule;
import funkin.data.event.SongEventRegistry;
import funkin.save.Save;

class CameraShakeEvent extends ScriptedSongEvent {
  function new() {
    super("extra-events-cameraShakeEvent");
  }

  public var eventTitle:String = "Extra Events | Camera Shake";
  public var isEnabled = null;

  // best if we could change both without placing two separate events
  public var DEFAULT_CAMGAME_INTENSITY:Float = 0.02;
  public var DEFAULT_CAMHUD_INTENSITY:Float = 0.01;
  public var DEFAULT_DURATION:Float = 4.0;
  public var DEFAULT_DIRECTION:Int = 2; // XY
  public var DEFAULT_EASE:String = "CLASSIC"; // Why classic instead of linear? for backwards compatibility with other mods that use this event before V0.9.0 (shout out geek off)

  public var shakeTweenGame:FlxTween = null;
  public var shakeTweenHUD:FlxTween = null;

  public var camShakeVal = null;
  public var camHUDShakeVal = null;
  public var camDirectionVal = null;
  public var camHUDDirectionVal = null;

  override function handleEvent(data) {
    if (PlayState.instance == null || PlayState.instance.currentStage == null) return;
    if (PlayState.instance.isMinimalMode) return;

    //trace('EASE: ${data.getString("ease")}');
    //trace('EASE DIR: ${data.getString("easeDir")}');

    isEnabled = Save.instance.modOptions.get('extra-events').isShakeEnabled;
    if (!isEnabled) return;

    var intensity_CamGame:Float = data.getFloat('intensityCamGame') != null ? data.getFloat('intensityCamGame') : DEFAULT_CAMGAME_INTENSITY;
    var intensity_CamHUD:Float = data.getFloat('intensityCamHUD') != null ? data.getFloat('intensityCamHUD') : DEFAULT_CAMHUD_INTENSITY;
    var duration:Float = data.getFloat('duration') != null ? data.getFloat('duration') : DEFAULT_DURATION;
    var direction:Int = data.getInt('direction') != null ? data.getInt('direction') : DEFAULT_DIRECTION;

    var durSeconds = Conductor.instance.stepLengthMs * duration / 1000;

    var ease:String = data.getString('ease') != null ? data.getString('ease') : DEFAULT_EASE;
    var easeDir:String = data.getString('easeDir') ?? SongEvent.DEFAULT_EASE_DIR;

    if (SongEvent.EASE_TYPE_DIR_REGEX.match(ease) || ease == "linear") easeDir = "";
    var easeFunction:Null<Float->Float>;

    //if (duration <= 0) {
    //  PolymodErrorHandler.showAlert('Event executing event | ${eventTitle}, Duration cannot be less or equal to 0.\nDuration must be greater than 0.');
    //  return;
    //}

    if (direction == 0) {
      direction = 0x01;
    } else if (direction == 1) {
      direction = 0x10;
    } else if (direction == 2) {
      direction = 0x11;
    }

    cancelShakeTweens();

    switch (ease) {
      case 'CLASSIC':
        if (intensity_CamGame != 0) {
            PlayState.instance.camGame?.shake(intensity_CamGame, durSeconds / PlayState.instance.playbackRate, null, true, direction);
        }
        if (intensity_CamHUD != 0) {
            PlayState.instance.camHUD?.shake(intensity_CamHUD, durSeconds / PlayState.instance.playbackRate, null, true, direction);
        }
      default:
        easeFunction = ReflectUtil.getAnonymousField(FlxEase, ease + easeDir);

        if (easeFunction == null){
          // trace("Invalid easing function: " + ease);
          return;
        }

        PlayState.instance.camGame._fxShakeDuration = durSeconds / PlayState.instance.playbackRate;
        camDirectionVal = PlayState.instance.camGame._fxShakeAxes = direction;

        PlayState.instance.camHUD._fxShakeDuration = durSeconds / PlayState.instance.playbackRate;
        camHUDDirectionVal = PlayState.instance.camHUD._fxShakeAxes = direction;

        if (PlayState.instance.camGame != null) {
            shakeTweenGame = FlxTween.num(
                PlayState.instance.camGame._fxShakeIntensity,
                intensity_CamGame,
                durSeconds / PlayState.instance.playbackRate,
                {ease: easeFunction, onComplete: function() {
                    PlayState.instance.camGame._fxShakeDuration = 0.0;
                }},
                function(value:Float) {
                    PlayState.instance.camGame._fxShakeIntensity = value;
                    //trace('camGame Intensity: ${PlayState.instance.camGame?._fxShakeIntensity}');
                }
            );
        }

        if (PlayState.instance.camHUD != null) {
            shakeTweenHUD = FlxTween.num(
                PlayState.instance.camHUD._fxShakeIntensity,
                intensity_CamHUD,
                durSeconds / PlayState.instance.playbackRate,
                {ease: easeFunction, onComplete: function() {
                    PlayState.instance.camHUD._fxShakeDuration = 0.0;
                }},
                function(value:Float) {
                    PlayState.instance.camHUD._fxShakeIntensity = value;
                    //trace('camHUD Intensity: ${PlayState.instance.camHUD?._fxShakeIntensity}');
                }
            );
        }
    }
  }

  function cancelShakeTweens() {
    shakeTweenGame?.cancel();
    shakeTweenHUD?.cancel();
  }

  // TODO: This is such an annoying bug, and I'm not sure how to make sense of this pause/resume code to begin with
  // So I'm leaving it to pr makers
  // The shake effect doesn't pause when the game is paused

  public override function onPause(e) {
    super.onPause(e);

    if (!shakeTweenGame?.finished) PlayState.instance.camGame?._fxShakeDuration = PlayState.instance.camGame?._fxShakeDuration ?? 0;
    if (!shakeTweenHUD?.finished) PlayState.instance.camHUD?._fxShakeDuration = PlayState.instance.camHUD?._fxShakeDuration ?? 0;

    PlayState.instance.camGame?._fxShakeIntensity ?? 0.0;
    PlayState.instance.camHUD?._fxShakeIntensity ?? 0.0;

    shakeTweenGame?.active = false;
    shakeTweenHUD?.active = false;
  }

  public override function onResume(e) {
    super.onResume(e);
    if (!shakeTweenGame?.finished) PlayState.instance.camGame?._fxShakeDuration = PlayState.instance.camGame?._fxShakeDuration ?? 0;
    if (!shakeTweenHUD?.finished) PlayState.instance.camHUD?._fxShakeDuration = PlayState.instance.camHUD?._fxShakeDuration ?? 0;

    PlayState.instance.camGame?._fxShakeIntensity ?? 0.0;
    PlayState.instance.camHUD?._fxShakeIntensity ?? 0.0;

    shakeTweenGame?.active = true;
    shakeTweenHUD?.active = true;
  }

  public override function onGameOver(event:ScriptEvent){
    super.onGameOver(event);
    resetShakeValues();
    cancelShakeTweens();
  }

  public override function onSongRetry(event:ScriptEvent){
    super.onSongRetry(event);
    resetShakeValues();
    cancelShakeTweens();
  }

  function resetShakeValues() {
    // Took a while to figure out, but setting the duration to 0 doesn't reset the intensity (seems obvious in retrospect),
    // so if you placed a shake event with easing that isn't classic,
    // the intensity won't reset upon song restart thus you'll be met with a shake effect very similar to classic
    PlayState.instance.camGame?._fxShakeDuration = 0;
    PlayState.instance.camGame?._fxShakeIntensity = 0.0;
    PlayState.instance.camHUD?._fxShakeDuration = 0;
    PlayState.instance.camHUD?._fxShakeIntensity = 0.0;
  }

  public override function getTitle() {
    return eventTitle;
  }

  override function getEventSchema(){
    return [
      {
        name: 'intensityCamGame',
        title: 'CamGame Intensity',
        defaultValue: 0.02,
        step: 0.001,
        min: 0,
        type: "float",
        units: 'x'
      },
      {
        name: 'intensityCamHUD',
        title: 'CamHUD Intensity',
        defaultValue: 0.01,
        step: 0.001,
        min: 0,
        type: "float",
        units: 'x'
      },
      {
        name: 'duration',
        title: 'Duration',
        defaultValue: 4.0,
        step: 0.5,
        min: 0,
        type: "float",
        units: 'steps'
      },
      {
        name: 'ease',
        title: 'Easing Type',
        defaultValue: 'CLASSIC',
        type: "enum",
        keys: [
          'Linear' => 'linear',
          'Classic/Instant' => 'CLASSIC',
          'Sine' => 'sine',
          'Quad' => 'quad',
          'Cube' => 'cube',
          'Quart' => 'quart',
          'Quint' => 'quint',
          'Expo' => 'expo',
          'Smooth Step' => 'smoothStep',
          'Smoother Step' => 'smootherStep',
          'Elastic' => 'elastic',
          'Back' => 'back',
          'Bounce' => 'bounce',
          'Circ' => 'circ',
        ]
      },
      {
        name: 'easeDir',
        title: 'Easing Direction',
        defaultValue: 'In',
        type: "enum",
        keys: ['In' => 'In', 'Out' => 'Out', 'In/Out' => 'InOut']
      },
      {
        name: 'direction',
        title: 'Direction',
        defaultValue: 2,
        type: "enum",
        keys: [
          "Horizontal" => 0,
          "Vertical" => 1,
          "Both" => 2
        ]
      }
    ];
  }
}
