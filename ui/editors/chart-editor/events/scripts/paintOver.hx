import funkin.play.PlayState;
import funkin.Conductor;
import funkin.modding.PolymodErrorHandler;
import funkin.play.event.ScriptedSongEvent;
import flixel.util.FlxColor;
import funkin.graphics.FunkinSprite;
import funkin.play.stage.StageProp;

class PaintOverEvent extends ScriptedSongEvent {
  function new() {
    super("extra-events-paintOver");
  }

  public var eventTitle:String = "Extra Events | Paint Over";

  /*
   * Paint over the stage with a given color and duration.
   */

   /*
   Stage color:
   - Color (black is the default)

   Characters:
   - BF, color (transparent turns them back to normal)
   - gf, color (transparent turns them back to normal)
   - dad, color (transparent turns them back to normal)

   Smooth transition? bool

   Custom colors (putting hex colors ignores the selected color from the chooser, so, no defaults for this one):
   - stage, hex color
   - bf, hex color
   - gf, hex color
   - dad, hex color
   */

  public var DEFAULT_COLOR:Int = 0;
  public var STAGE_DEFAULT_COLOR:Int = 11; // white
  public var DEFAULT_DURATION:Float = 4.0;
  public var DEFAULT_ISSMOOTH:Bool = true; // Instant or linear

  public var stageCoverBox:FunkinSprite;

  override function onSongStart(e) {
    stageCoverBox = new FunkinSprite().makeSolidColor(FlxG.width * 2, FlxG.height * 2, 0xFFFFFFFF);
   	stageCoverBox.camera = PlayState.instance.camGame;
   	stageCoverBox.scrollFactor.set(0, 0);
   	stageCoverBox.zIndex = -300;
   	stageCoverBox.alpha = 0.0001;
   	PlayState.instance.currentStage?.add(stageCoverBox);
   	PlayState.instance.currentStage?.refresh();
    trace('song start | Is BF visible? ${PlayState.instance.currentStage?.getBoyfriend()?.visible}');
    trace('song start | BF alpha: ${PlayState.instance.currentStage?.getBoyfriend()?.alpha}');
  }

  override function onSongLoaded(e) {
      trace('song loaded | Is BF visible? ${PlayState.instance.currentStage?.getBoyfriend()?.visible}');
      trace('song loaded | BF alpha: ${PlayState.instance.currentStage?.getBoyfriend()?.alpha}');
  }

  override function onSongRetry(e) {
      stageCoverBox?.destroy(); // Meant to fix a duplication issue hopefully???
      PlayState.instance.currentStage?.getDad()?.color = 0xFFFFFFFF;
      PlayState.instance.currentStage?.getGirlfriend()?.color = 0xFFFFFFFF;
      PlayState.instance.currentStage?.getBoyfriend()?.color = 0xFFFFFFFF;
      showProps();
  }

  override function onGameOver(e) {
      stageCoverBox?.destroy();
      PlayState.instance.currentStage?.getDad()?.color = 0xFFFFFFFF;
      PlayState.instance.currentStage?.getGirlfriend()?.color = 0xFFFFFFFF;
      PlayState.instance.currentStage?.getBoyfriend()?.color = 0xFFFFFFFF;
      showProps();
  }

  override function handleEvent(data) {
    if (PlayState.instance == null || PlayState.instance.currentStage == null) return;
    if (PlayState.instance.isMinimalMode) return;

    var duration:Float = data.getFloat('duration') ?? DEFAULT_DURATION;
    //var applyToHud:Bool = data.getBool('smooth') ?? DEFAULT_ISSMOOTH;

    var stageColor:Int = data.getInt('stageColor') ?? STAGE_DEFAULT_COLOR;
    var stageColorReset:Bool = stageColor == 12;
    var bf_charColor:Int = data.getInt('bfColor') ?? DEFAULT_COLOR;
    var dad_charColor:Int = data.getInt('dadColor') ?? DEFAULT_COLOR;
    var gf_charColor:Int = data.getInt('gfColor') ?? DEFAULT_COLOR;

    var stageColorHex:String = data.getString('stageColorHex') ?? null;
    var bf_charColorHex:String = data.getString('bfColorHex') ?? null;
    var dad_charColorHex:String = data.getString('dadColorHex') ?? null;
    var gf_charColorHex:String = data.getString('gfColorHex') ?? null;

    var durSeconds = Conductor.instance.stepLengthMs * duration / 1000;

    trace('Stage colors: ${stageColor}, ${stageColorHex}');
    trace('character colors: BF: ${bf_charColor}, DAD: ${dad_charColor}, GF: ${gf_charColor}');
    trace('character color hex: BF: ${bf_charColorHex}, DAD: ${dad_charColorHex}, GF: ${gf_charColorHex}');

    switch (stageColor) {
      case 0: // Black
        stageColor = FlxColor.fromString("#020001");
      case 1: // Blue
        stageColor = 0xFF0000FF;
      case 2: // Brown
        stageColor = 0xFF8B4513;
      case 3: // Cyan
        stageColor = 0xFF00FFFF;
      case 4: // Gray
        stageColor = 0xFF808080;
      case 5: // Green
        stageColor = 0xFF008000;
      case 6: // Lime
        stageColor = 0xFF00FF00;
      case 7: // Magenta
        stageColor = 0xFFFF00FF;
      case 8: // Orange
        stageColor = 0xFFFFA500;
      case 9: // Purple
        stageColor = 0xFF800080;
      case 10: // Red
        stageColor = 0xFFFF0000;
      case 11: // Close to white
        stageColor = FlxColor.fromString("#fcf9fb");
      case 12: // White
        stageColor = 0xFFFFFFFF; // Reset color
      case 13: // Yellow
        stageColor = 0xFFFFFF00;
    }

    switch (bf_charColor) {
      case 0: // Black
        bf_charColor = FlxColor.fromString("#020001");
      case 1: // Blue
        bf_charColor = 0xFF0000FF;
      case 2: // Brown
        bf_charColor = 0xFF8B4513;
      case 3: // Cyan
        bf_charColor = 0xFF00FFFF;
      case 4: // Gray
        bf_charColor = 0xFF808080;
      case 5: // Green
        bf_charColor = 0xFF008000;
      case 6: // Lime
        bf_charColor = 0xFF00FF00;
      case 7: // Magenta
        bf_charColor = 0xFFFF00FF;
      case 8: // Orange
        bf_charColor = 0xFFFFA500;
      case 9: // Purple
        bf_charColor = 0xFF800080;
      case 10: // Red
        bf_charColor = 0xFFFF0000;
      case 11: // Transparent
        bf_charColor = FlxColor.fromString("#fcf9fb");
      case 12: // White
        bf_charColor = 0xFFFFFFFF; // Reset color
      case 13: // Yellow
        bf_charColor = 0xFFFFFF00;
    }

    switch (dad_charColor) {
      case 0: // Black
        dad_charColor = FlxColor.fromString("#020001");
      case 1: // Blue
        dad_charColor = 0xFF0000FF;
      case 2: // Brown
        dad_charColor = 0xFF8B4513;
      case 3: // Cyan
        dad_charColor = 0xFF00FFFF;
      case 4: // Gray
        dad_charColor = 0xFF808080;
      case 5: // Green
        dad_charColor = 0xFF008000;
      case 6: // Lime
        dad_charColor = 0xFF00FF00;
      case 7: // Magenta
        dad_charColor = 0xFFFF00FF;
      case 8: // Orange
        dad_charColor = 0xFFFFA500;
      case 9: // Purple
        dad_charColor = 0xFF800080;
      case 10: // Red
        dad_charColor = 0xFFFF0000;
      case 11: // Transparent
        dad_charColor = FlxColor.fromString("#fcf9fb");
      case 12: // White
        dad_charColor = 0xFFFFFFFF;
      case 13: // Yellow
        dad_charColor = 0xFFFFFF00;
    }

    switch (gf_charColor) {
      case 0: // Black
        gf_charColor = FlxColor.fromString("#020001");
      case 1: // Blue
        gf_charColor = 0xFF0000FF;
      case 2: // Brown
        gf_charColor = 0xFF8B4513;
      case 3: // Cyan
        gf_charColor = 0xFF00FFFF;
      case 4: // Gray
        gf_charColor = 0xFF808080;
      case 5: // Green
        gf_charColor = 0xFF008000;
      case 6: // Lime
        gf_charColor = 0xFF00FF00;
      case 7: // Magenta
        gf_charColor = 0xFFFF00FF;
      case 8: // Orange
        gf_charColor = 0xFFFFA500;
      case 9: // Purple
        gf_charColor = 0xFF800080;
      case 10: // Red
        gf_charColor = 0xFFFF0000;
      case 11: // Close to white
        gf_charColor = FlxColor.fromString("#fcf9fb");
      case 12: // White
        gf_charColor = 0xFFFFFFFF; // Reset color
      case 13: // Yellow
        gf_charColor = 0xFFFFFF00;
    }

    // TODO: Tween it later
    if ((stageColorReset || stageColor == 0xFFFFFFFF) && stageColorHex == null) {
        stageCoverBox?.alpha = 0.001;
        showProps();
    } else {
        stageCoverBox?.alpha = 1;
        hideProps();
    }

    if (stageColorHex == null) {
        stageCoverBox?.color = stageColor;
    } else {
        stageCoverBox?.color = FlxColor.fromString(stageColorHex);
    }
    if (dad_charColorHex == null || dad_charColorHex == "") {
        PlayState.instance.currentStage?.getDad()?.color = dad_charColor;
    } else {
        PlayState.instance.currentStage?.getDad()?.color = FlxColor.fromString(dad_charColorHex);
    }
    if (bf_charColorHex == null || bf_charColorHex == "") {
        PlayState.instance.currentStage?.getBoyfriend()?.color = bf_charColor;
    } else {
        PlayState.instance.currentStage?.getBoyfriend()?.color = FlxColor.fromString(bf_charColorHex);
    }
    if (gf_charColorHex == null || gf_charColorHex == "") {
        PlayState.instance.currentStage?.getGirlfriend()?.color = gf_charColor;
    } else {
        PlayState.instance.currentStage?.getGirlfriend()?.color = FlxColor.fromString(gf_charColorHex);
    }

  }

  function hideProps() {
    for (stageProp in PlayState.instance.currentStage.members) {
        if (Std.isOfType(stageProp, StageProp)) {
            if (stageProp.name == 'bf' || stageProp.name == 'dad' || stageProp.name == 'gf') {
                // Exclude.
                continue;
            }
            stageProp?.alpha = 0.0001;
        }
    }
  }

  function showProps() {
    for (stageProp in PlayState.instance.currentStage.members) {
        if (Std.isOfType(stageProp, StageProp)) {
            if (stageProp.name == 'bf' || stageProp.name == 'dad' || stageProp.name == 'gf') {
                // Exclude.
                continue;
            }
            stageProp?.alpha = 1;
        }
    }
  }

  public override function getTitle() {
    return eventTitle;
  }

  override function getEventSchema(){
    return [
      {
        name: 'duration',
        title: 'Duration',
        defaultValue: 4,
        step: 0.5,
        min: 0.5,
        type: "float",
        units: 'steps'
      },
      {
        name: 'applyToHud',
        title: 'Apply to camHUD',
        defaultValue: false,
        type: "bool"
      },
      {
        name: 'stageColor',
        title: 'Stage Color',
        defaultValue: 11,
        type: "enum",
        keys: [
          "Black" => 0,
          "Blue" => 1,
          "Brown" => 2,
          "Cyan" => 3,
          "Gray" => 4,
          "Green" => 5,
          "Lime" => 6,
          "Magenta" => 7,
          "Orange" => 8,
          "Purple" => 9,
          "Red" => 10,
          "White" => 11,
          "Reset Color" => 12,
          "Yellow" => 13
        ]
      },
      {
        name: 'bfColor',
        title: 'BF Color',
        defaultValue: 0,
        type: "enum",
        keys: [
          "Black" => 0,
          "Blue" => 1,
          "Brown" => 2,
          "Cyan" => 3,
          "Gray" => 4,
          "Green" => 5,
          "Lime" => 6,
          "Magenta" => 7,
          "Orange" => 8,
          "Purple" => 9,
          "Red" => 10,
          "White" => 11,
          "Reset Color" => 12,
          "Yellow" => 13
        ]
      },
      {
        name: 'dadColor',
        title: 'DAD Color',
        defaultValue: 0,
        type: "enum",
        keys: [
          "Black" => 0,
          "Blue" => 1,
          "Brown" => 2,
          "Cyan" => 3,
          "Gray" => 4,
          "Green" => 5,
          "Lime" => 6,
          "Magenta" => 7,
          "Orange" => 8,
          "Purple" => 9,
          "Red" => 10,
          "White" => 11,
          "Reset Color" => 12,
          "Yellow" => 13
        ]
      },
      {
        name: 'gfColor',
        title: 'GF Color',
        defaultValue: 0,
        type: "enum",
        keys: [
          "Black" => 0,
          "Blue" => 1,
          "Brown" => 2,
          "Cyan" => 3,
          "Gray" => 4,
          "Green" => 5,
          "Lime" => 6,
          "Magenta" => 7,
          "Orange" => 8,
          "Purple" => 9,
          "Red" => 10,
          "White" => 11,
          "Reset Color" => 12,
          "Yellow" => 13
        ]
      },
      {
          name: 'advanced',
          title: 'Advanced',
          type: "frame",
          collapsible: true,
          children: [
              {
                name: "stageColorHex",
                title: "Stage Color",
                defaultValue: "",
                type: "string"
              },
              {
                name: "bfColorHex",
                title: "Bf Color",
                defaultValue: "",
                type: "string"
              },
              {
                name: "dadColorHex",
                title: "Dad Color",
                defaultValue: "",
                type: "string"
              },
              {
                name: "gfColorHex",
                title: "GF Color",
                defaultValue: "",
                type: "string"
              }
          ]
      }
    ];
  }
}
