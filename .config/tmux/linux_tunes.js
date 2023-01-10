// adopted from https://github.com/esenliyim/sp-tray
const { Gio } = imports.gi;

//dbus constants
const dest = "org.mpris.MediaPlayer2.ncspot";
const path = "/org/mpris/MediaPlayer2";
const spotifyDbus = `<node>
<interface name="org.mpris.MediaPlayer2.Player">
    <property name="PlaybackStatus" type="s" access="read"/>
    <property name="Metadata" type="a{sv}" access="read"/>
</interface>
</node>`;

let spotifyProxyWrapper = Gio.DBusProxy.makeProxyWrapper(spotifyDbus);
let spotifyProxy = spotifyProxyWrapper(Gio.DBus.session, dest, path);
let status = spotifyProxy.PlaybackStatus;

let maxTitleLength = 35;
let maxArtistLength = 35;
let maxAlbumLength = 35;

let output = "";

if (status) {
    let metadata = spotifyProxy.Metadata;

    let format = "{artist} | {track}"

    // if (status == "Paused") {
    //     format = " {artist} | {track}"
    // } else if (status == "Playing") {
    //     format = " {artist} | {track}"
    // }

    if (metadata) {

        let title = metadata['xesam:title'].get_string()[0];
        if (title.length > maxTitleLength) {
            title = title.slice(0,maxTitleLength) + "...";
        }

        let album = metadata['xesam:album'].get_string()[0];
        if (album.length > maxAlbumLength) {
            album = album.slice(0,maxAlbumLength) + "...";
        }

        let artist = metadata['xesam:artist'].get_strv()[0];
        if (artist.length > maxArtistLength) {
            artist = artist.slice(0,maxArtistLength) + "...";
        }

        output = format.replace("{artist}", artist).replace("{track}", title).replace("{album}", album);
    }
}

print(output)
