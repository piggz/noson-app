/*
 * Copyright (C) 2013, 2014, 2015, 2016
 *      Jean-Luc Barriere <jlbarriere68@gmail.com>
 *      Andrew Hayzen <ahayzen@gmail.com>
 *      Daniel Holm <d.holmen@gmail.com>
 *      Victor Thompson <victor.thompson@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import Sailfish.Silica 1.0

// generic page for music, could be useful for bottomedge implementation
Page {
    id: thisPage
    //anchors {
    //    bottomMargin: musicToolbar.visible ? musicToolbar.height : 0
    //}

    property string pageTitle: ""
    property Flickable pageFlickable: null
    property int searchResultsCount
    property bool isListView: false
    property SilicaListView listview: null
    property bool isRoot: true // by default this page is root
    property bool showToolbar: true // by default enable the music tool bar

    property alias multiView: viewType.visible
    property alias searchable: find.visible
    property alias selectable: selection.visible
    property alias addVisible: add.visible
    property alias optionsMenuVisible: optionsMenu.visible
    property alias selectAllVisible: selectAll.visible
    property alias selectNoneVisible: selectNone.visible
    property alias addToQueueVisible: addToQueue.visible
    property alias addToPlaylistVisible: addToPlaylist.visible
    property alias removeSelectedVisible: removeSelected.visible
    property alias footer: footerToolbar
    property alias header: pageHeader
    property alias pageMenu: pageMenu._contentColumn
    property alias optionsMenu: optionsMenu._contentColumn
    property alias musicToolbar: musicToolbar
    
    default property alias _content: _contentItem.data
    
    state: "default"
    states: [
        State {
            name: "default"
        },
        State {
            name: "selection"
        },
        State {
            name: "zone"
        },
        State {
            name: "group"
        }
    ]

    signal goUpClicked // action for a non-root page
    signal searchClicked
    signal selectAllClicked
    signal selectNoneClicked
    signal closeSelectionClicked
    signal addToQueueClicked
    signal addToPlaylistClicked
    signal addClicked
    signal removeSelectedClicked

    signal reloadClicked

    // available signal for page 'zone'
    signal groupZoneClicked
    signal groupAllZoneClicked

    // available signal for page 'group'
    signal closeRoomClicked
    signal groupRoomClicked
    signal groupNoneRoomClicked

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            id: pageMenu
        }
        
        Column {
            id: column
            width: thisPage.width
            height: thisPage.height

            PageHeader {
                id: pageHeader
                title: pageTitle
            }
            Item {
                id: _contentItem
                width: parent.width
                height: parent.height - pageHeader.height - footerToolbar.height - (musicToolbar.visible ? musicToolbar.height : 0)
            }

            //Bottom toolbar
            Item {
                id: footerToolbar
                height: units.gu(7.25)
                width: parent.width

                Rectangle {
                    id: defaultToolBar
                    anchors.fill: parent
                    color: styleMusic.playerControls.backgroundColor
                    opacity: thisPage.state === "default" ? 1.0 : 0.0
                    enabled: opacity > 0

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: units.gu(1)
                        anchors.leftMargin: units.gu(1)
                        anchors.rightMargin: units.gu(1)
                        height: units.gu(5)
                        color: "transparent"

                         Row {
                            spacing: units.gu(1)
                            anchors.fill: parent

                            MusicIcon {
                                source: "qrc:/images/media-playlist.svg"
                                height: units.gu(5)
                                label.text: player.queueInfo
                                label.font.pixelSize: units.fx("x-small")

                                    onClicked: {
                                    var page = mainView.pageStack.currentPage;
                                    if (page.objectName === "queuePage")
                                        pageStack.pop();
                                    else if (page.pageTitle === qsTr("Now playing"))
                                        page.isListView = !page.isListView;
                                    else if (!mainView.wideAspect)
                                        pageStack.push("qrc:/sfos/pages/QueueView.qml");
                                    }
                            }

                            MusicIcon {
                                source: "qrc:/images/location.svg"
                                height: units.gu(5)
                                label.text: currentZoneTag
                                label.font.pixelSize: units.fx("x-small")

                                onClicked: pageStack.push("qrc:/sfos/pages/Zones.qml")
                            }

                            MusicIcon {
                                id: viewType
                                visible: false
                                source: isListView ? "qrc:/images/view-grid-symbolic.svg" : "qrc:/images/view-list-symbolic.svg"
                                height: units.gu(5)
                                onClicked: {
                                    isListView = !isListView
                                }
                            }

                            MusicIcon {
                                id: find
                                visible: false
                                source: "qrc:/images/find.svg"
                                height: units.gu(5)
                                onClicked: searchClicked()
                            }

                            MusicIcon {
                                id: selection
                                visible: false
                                source: "qrc:/images/select.svg"
                                height: units.gu(5)
                                onClicked: thisPage.state = "selection"
                            }

                            MusicIcon {
                                id: add
                                visible: false
                                source: "qrc:/images/add.svg"
                                height: units.gu(5)
                                label.text: qsTr("Add")
                                label.font.pixelSize: units.fx("x-small")
                                onClicked: addClicked()
                            }
                        }
                    }
                }

                Rectangle {
                    id: selectionToolBar
                    anchors.fill: parent
                    color: styleMusic.playerControls.backgroundColor

                    opacity: thisPage.state === "selection" ? 1.0 : 0.0
                    enabled: opacity > 0
                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: units.gu(1)
                        anchors.leftMargin: units.gu(1)
                        anchors.rightMargin: units.gu(1)
                        height: units.gu(5)
                        color: "transparent"

                        Row {
                            spacing: units.gu(1)

                            MusicIcon {
                                id: closeSelection
                                visible: true
                                source: "qrc:/images/close.svg"
                                height: units.gu(5)
                                label.text: qsTr("Close")
                                label.font.pixelSize: units.fx("x-small")
                                onClicked: {
                                    thisPage.state = "default"
                                    closeSelectionClicked()
                                }
                            }

                            MusicIcon {
                                id: selectAll
                                visible: true
                                source: "qrc:/images/select.svg"
                                height: units.gu(5)
                                label.text: qsTr("All")
                                label.font.pixelSize: units.fx("x-small")
                                onClicked: selectAllClicked()
                            }

                            MusicIcon {
                                id: selectNone
                                visible: true
                                source: "qrc:/images/select-undefined.svg"
                                height: units.gu(5)
                                label.text: qsTr("Clear")
                                label.font.pixelSize: units.fx("x-small")
                                onClicked: selectNoneClicked()
                            }

                            MusicIcon {
                                id: addToQueue
                                visible: true
                                source: "qrc:/images/add.svg"
                                height: units.gu(5)
                                onClicked: addToQueueClicked()
                            }

                            MusicIcon {
                                id: addToPlaylist
                                visible: true
                                source: "qrc:/images/add-to-playlist.svg"
                                height: units.gu(5)
                                onClicked: addToPlaylistClicked()
                            }
                        }

                        MusicIcon {
                            id: removeSelected
                            anchors.right: parent.right
                            visible: true
                            source: "qrc:/images/delete.svg"
                            height: units.gu(5)
                            onClicked: removeSelectedClicked()
                        }
                    }
                }

                Rectangle {
                    id: zoneToolBar
                    anchors.fill: parent
                    color: styleMusic.playerControls.backgroundColor

                    opacity: thisPage.state === "zone" ? 1.0 : 0.0
                    enabled: opacity > 0
                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: units.gu(1)
                        anchors.leftMargin: units.gu(1)
                        anchors.rightMargin: units.gu(1)
                        height: units.gu(5)
                        color: "transparent"

                        Row {
                            spacing: units.gu(1)

                            MusicIcon {
                                source: "qrc:/images/media-playlist.svg"
                                height: units.gu(5)
                                label.text: player.queueInfo
                                label.font.pixelSize: units.fx("x-small")

                                onClicked: {
                                    pageStack.pop();
                                    var page = mainView.pageStack.currentPage;
                                    if (!mainView.wideAspect && page.objectName !== "queuePage")
                                        pageStack.push("qrc:/sfos/pages/QueueView.qml");
                                }
                            }

                            MusicIcon {
                                id: reload
                                visible: true
                                source: "qrc:/images/reload.svg"
                                height: units.gu(5)
                                onClicked: reloadClicked()
                            }

                            MusicIcon {
                                id: groupAll
                                visible: true
                                source: "qrc:/images/select.svg"
                                height: units.gu(5)
                                label.text: qsTr("All")
                                label.font.pixelSize: units.fx("x-small")
                                onClicked: groupAllZoneClicked()
                            }

                            MusicIcon {
                                id: group
                                visible: true
                                source: "qrc:/images/group.svg"
                                height: units.gu(5)
                                label.text: qsTr("Done")
                                label.font.pixelSize: units.fx("x-small")
                                onClicked: groupZoneClicked()
                            }
                        }
                    }
                }

                Rectangle {
                    id: groupToolBar
                    anchors.fill: parent
                    color: styleMusic.playerControls.backgroundColor

                    opacity: thisPage.state === "group" ? 1.0 : 0.0
                    enabled: opacity > 0
                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: units.gu(1)
                        anchors.leftMargin: units.gu(1)
                        anchors.rightMargin: units.gu(1)
                        height: units.gu(5)
                        color: "transparent"

                        Row {
                            spacing: units.gu(1)

                            MusicIcon {
                                source: "qrc:/images/location.svg"
                                height: units.gu(5)
                                label.text: currentZoneTag
                                label.font.pixelSize: units.fx("x-small")
                            }

                            MusicIcon {
                                id: groupAllRoom
                                visible: true
                                source: "qrc:/images/select-undefined.svg"
                                height: units.gu(5)
                                label.text: qsTr("None")
                                label.font.pixelSize: units.fx("x-small")
                                onClicked: groupNoneRoomClicked()
                            }

                            MusicIcon {
                                id: groupRoom
                                visible: true
                                source: "qrc:/images/group.svg"
                                height: units.gu(5)
                                label.text: qsTr("Done")
                                label.font.pixelSize: units.fx("x-small")
                                onClicked: groupRoomClicked()
                            }
                        }
                    }
                }
            }

            Loader {
                id: musicToolbar
                active: true
                height: visible ? units.gu(7.25) : 0
                anchors { // start offscreen
                    left: parent.left
                    right: parent.right
                }
                asynchronous: true
                source: "qrc:/sfos/components/MusicToolbar.qml"
                visible: status === Loader.Ready && !noZone && (showToolbar === undefined || showToolbar)
            }
        }

        //Noson options menu
        PushUpMenu {
            id: optionsMenu
            MenuItem {
                    text: qsTr("Standby Timer")
                    onClicked: {
                        dialogSleepTimer.open();
                    }
            }
            MenuItem {
                    text: qsTr("Sonos Settings")
                    onClicked: {
                        dialogSoundSettings.open();
                    }
            }
            MenuItem {
                    text: qsTr("General Settings")
                    onClicked: {
                        dialogApplicationSettings.open();
                    }
            }
            MenuItem {
                    text: qsTr("About")
                    onClicked: {
                        dialogAbout.open();
                    }
            }
        }
    }
}
