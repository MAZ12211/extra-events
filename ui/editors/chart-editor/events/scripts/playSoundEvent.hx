import funkin.play.PlayState;
import flixel.FlxCamera;
import funkin.modding.PolymodErrorHandler;

import funkin.play.event.SongEvent;
import funkin.play.event.ScriptedSongEvent;

import funkin.modding.module.ModuleHandler;
import funkin.modding.module.ScriptedModule;
import funkin.data.event.SongEventRegistry;
import funkin.audio.FunkinSound;

class PlaySoundEvent extends ScriptedSongEvent {
  function new() {
    super("extra-events-playSoundEvent");
  }
  // Code is taken from Spooky Mix's Play Sound event by Denoohay

  public var eventTitle:String = "Extra Events | Play Sound";

  override function handleEvent(data):Void {
    if (PlayState.instance == null || PlayState.instance.currentStage == null) return;
    if (PlayState.instance.isMinimalMode) return;
    var audioName = data.getString('audioName');
    if (audioName == null || audioName == "") {
      PolymodErrorHandler.showAlert('Error executing event | ${eventTitle}, Could not find audio file in ${Paths.sound(audioName)}.\nDouble check the audio name, its path, and its extension.');
      return;
    }

    trace('Playing sound: ${audioName}');
    FunkinSound.playOnce(Paths.sound(audioName), data.getFloat('vol'));
  }

  public override function getTitle() {
    return eventTitle;
  }

  override function getEventSchema(){
    return [
      {
        name: "audioName",
        title: "File Name",
        defaultValue: "",
        type: "string",
        units: ".ogg/.mp3"
      },
      {
        name: 'vol',
        title: 'Volume level',
        defaultValue: 1.0,
        min: 0.1, /*Why play a muted sound?*/
        max: 1.0,
        step: 0.1,
        type: "float"
      }
    ];
  }
}
