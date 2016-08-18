// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import {Socket, Presence} from "phoenix"
let socket = new Socket("/socket", {params: {mac: window.mac}})

socket.connect()

// Having trouble trying to get this to actually work when firmware is built
let worksOnNerves = false

if (worksOnNerves) {

  // connection-list
  let chore_lobby = socket.channel("chore:lobby", {})
  let presences = {}

  let listBy = (id, {metas: [first, ...rest]}) => {
    first.mac = id
    first.count = rest.length + 1
    return first
  }

  let render_captives = (presences) => {
    let userList = document.getElementById("user-list")
    if (!userList)return;
    userList.innerHTML = Presence.list(presences, listBy)
      .map(presence =>
        "<tr>" +
          "<td>" + presence.mac + "</td>" +
          "<td>" + presence.ip + "</td>" +
          "<td>" + presence.status + "</td>" +
          "<td>" + presence.step + "</td>" +
        "</tr>"
      ).join("")
  }

  chore_lobby.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    render_captives(presences)
  })

  chore_lobby.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    render_captives(presences)
    chore_lobby.push("fetch_connection_state", {})
  })

  let render_connections = (connections) => {
    let connectionList = document.getElementById("connection-list")
    if (!connectionList)return;

    connectionList.innerHTML = connections
      .map(connection =>
        "<tr>" +
          "<td>" + connection.mac + "</td>" +
          "<td>" + connection.ip + "</td>" +
          "<td>" + connection.status + "</td>" +
          "<td>" + connection.step + "</td>" +
          "<td class=\"right aligned collapsing\">" +
            "<button data-mac=\"" + connection.mac + "\" class=\"disconnect negative ui button\">Disconnect</button>" +
          "</td>" +
        "</tr>"
      ).join("")

    $(".disconnect").click(function() {
      console.log("foo")
      chore_lobby.push("disconnect_user", {mac: mac})
    });
  }

  chore_lobby.on("connection_state", state => {
    render_connections(state.connections)
  })

  chore_lobby.join()
}
