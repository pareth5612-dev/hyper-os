/*
 * Hyper OS — install slideshow
 */
import QtQuick 2.0
import calamares.slideshow 1.0

Presentation
{
    id: presentation

    Timer
    {
        interval: 20000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide
    {
        title: "Welcome to Hyper OS"
        text: "A lightning-fast, stable Arch-based desktop that works the minute it boots. Install it, reboot, done."
        image: "bolt.png"
    }

    Slide
    {
        title: "Hyprland, pre-tuned"
        text: "A curated Wayland setup sits behind this installer: tiling, rounded windows, one consistent theme. No three-hour setup marathon."
        image: "bolt.png"
    }

    Slide
    {
        title: "Yours, not ours"
        text: "Add a software profile any time with hyper-setup: Gaming, Development or plain Standard. Nothing is locked in, nothing is forced."
        image: "bolt.png"
    }
}