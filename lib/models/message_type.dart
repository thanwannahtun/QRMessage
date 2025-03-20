import 'package:flutter/material.dart';

enum MessageFeelingType {
  happy(
    backgroundColor: Color(0xFFFFD700),
    // Gold
    value: 'Happy',
    emojis: ['😊', '😃', '😁', '😄', '😆'],
    soundEffect: 'sounds/child-laughing-sound-effect.mp3',
    animation: 'assets/animations/happy.json',
    fontStyle: TextStyle(
      fontFamily: 'ComicSans',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  funny(
    backgroundColor: Color(0xFFFFD700),
    // Gold
    value: 'Funny',
    emojis: ['😹', '😃', '😁', '😄', '😆'],
    soundEffect: 'sounds/laughing-man.mp3',
    animation: 'assets/animations/happy.json',
    fontStyle: TextStyle(
      fontFamily: 'ComicSans',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  sad(
    backgroundColor: Color(0xFF1E90FF),
    // DodgerBlue
    value: 'Sad',
    emojis: ['😢', '😞', '😭', '😔', '😟'],
    // soundEffect: 'sounds/sad.mp3',
    soundEffect: 'sounds/cartoon-angry-woman-scream.mp3',
    animation: 'assets/animations/sad.json',
    fontStyle: TextStyle(
      fontFamily: 'Arial',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  wow(
    backgroundColor: Color(0xFFFFA500),
    // Orange
    value: 'Wow',
    emojis: ['😲', '😮', '😯', '😳', '😱'],
    soundEffect: 'sounds/vinyl-stop-sound-effect.mp3',
    animation: 'assets/animations/wow.json',
    fontStyle: TextStyle(
      fontFamily: 'Verdana',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  good(
    backgroundColor: Color(0xFF32CD32),
    // LimeGreen
    value: 'Good',
    emojis: ['👍', '😊', '👌', '😌', '😇'],
    soundEffect: 'sounds/music-box-note-14514.mp3',
    animation: 'assets/animations/good.json',
    fontStyle: TextStyle(
      fontFamily: 'Helvetica',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  angry(
    backgroundColor: Color(0xFFFF0000),
    // Red
    value: 'Angry',
    emojis: ['😡', '😠', '🤬', '😤', '😾'],
    soundEffect: 'sounds/short-echo-fart.mp3',
    animation: 'assets/animations/angry.json',
    fontStyle: TextStyle(
      fontFamily: 'Impact',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  love(
    backgroundColor: Color(0xFFFF69B4),
    // HotPink
    value: 'Love',
    emojis: ['😍', '😘', '❤️', '💕', '💖'],
    soundEffect: 'sounds/music-box-note-14514.mp3',
    animation: 'assets/animations/love.json',
    fontStyle: TextStyle(
      fontFamily: 'Cursive',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  surprised(
    backgroundColor: Color(0xFF8A2BE2),
    // BlueViolet
    value: 'Surprised',
    emojis: ['😲', '😮', '😯', '😳', '😱'],
    soundEffect:
        'sounds/ascent-braam-magma-brass-d-cinematic-trailer-sound-effect.mp3',
    animation: 'assets/animations/surprised.json',
    fontStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  confused(
    backgroundColor: Color(0xFF808080),
    // Gray
    value: 'Confused',
    emojis: ['😕', '😟', '😵', '🤔', '😐'],
    soundEffect: 'sounds/laughing-man.mp3',
    animation: 'assets/animations/confused.json',
    fontStyle: TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  excited(
    backgroundColor: Color(0xFFFF4500),
    // OrangeRed
    value: 'Excited',
    emojis: ['😆', '😃', '😁', '😄', '🤩'],
    soundEffect: 'sounds/funny-laughing-sound.mp3',
    animation: 'assets/animations/excited.json',
    fontStyle: TextStyle(
      fontFamily: 'Tahoma',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  scared(
    // backgroundColor: Color(0xCB000000),
    backgroundColor: Color(0xFF700000),
    // Black
    value: 'Scared',
    emojis: ['😱', '😨', '😰', '😖', '😧'],
    soundEffect:
        'sounds/ascent-braam-magma-brass-d-cinematic-trailer-sound-effect.mp3',
    animation: 'assets/animations/scared.json',
    fontStyle: TextStyle(
      fontFamily: 'Courier New',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  bored(
    backgroundColor: Color(0xFF708090),
    // SlateGray
    value: 'Bored',
    emojis: ['😒', '😐', '😴', '🙄', '😑'],
    soundEffect: 'sounds/music-box-note-14514.mp3',
    animation: 'assets/animations/bored.json',
    fontStyle: TextStyle(
      fontFamily: 'Verdana',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  tired(
    backgroundColor: Color(0xFF2F4F4F),
    // DarkSlateGray
    value: 'Tired',
    emojis: ['😴', '😪', '😫', '😓', '😥'],
    soundEffect: 'sounds/short-echo-fart.mp3',
    animation: 'assets/animations/tired.json',
    fontStyle: TextStyle(
      fontFamily: 'Arial',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  proud(
    backgroundColor: Color(0xFFDAA520),
    // GoldenRod
    value: 'Proud',
    emojis: ['😌', '😎', '😊', '😇', '🤗'],
    soundEffect: 'sounds/ringtone.mp3',
    animation: 'assets/animations/proud.json',
    fontStyle: TextStyle(
      fontFamily: 'ComicSans',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  embarrassed(
    backgroundColor: Color(0xFFFF6347),
    // Tomato
    value: 'Embarrassed',
    emojis: ['😳', '😅', '🙈', '🙊', '😬'],
    soundEffect: 'sounds/funny-laughing-sound.mp3',
    animation: 'assets/animations/embarrassed.json',
    fontStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  celebration(
    backgroundColor: Color(0xFF043FF3),
    value: 'Celebration',
    emojis: ['️🎊', '🎈', '✨', '🎉', '🥂', '🎇'],
    soundEffect: 'sounds/funny-laughing-sound.mp3',
    animation: 'assets/animations/embarrassed.json',
    fontStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  music(
    backgroundColor: Color(0xFFD67AFF),
    value: 'Music',
    emojis: ['️️🎶', '🎵', '🎤', '🎸', '🥁', '🎹', '‍🎺'],
    soundEffect: 'sounds/music-box-note-14514.mp3',
    animation: 'assets/animations/embarrassed.json',
    fontStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  photography(
    backgroundColor: Colors.black,
    value: 'Photography',
    emojis: ['️️🎬', '🎥', '📷', '📹', '🔎', '📸', '📱'],
    soundEffect: 'sounds/music-box-note-14514.mp3',
    animation: 'assets/animations/embarrassed.json',
    fontStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  business(
    backgroundColor: Color(0xFFDAA520),
    value: 'Business',
    emojis: ['️️💴', '💵', '💶', '💷', '💲', '💰'],
    soundEffect: 'sounds/music-box-note-14514.mp3',
    animation: 'assets/animations/embarrassed.json',
    fontStyle: TextStyle(
      fontFamily: 'ComicSans',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  foodAndSnacks(
    backgroundColor: Color(0xFFEE58AC),
    value: 'Food & Snacks',
    emojis: ['️🍕', '🍔', '🍟', '🧀', '🌭', '🍿', '🍞'],
    soundEffect: 'sounds/food-and-snacks.m4a',
    animation: 'assets/animations/embarrassed.json',
    fontStyle: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  fruitsAndVegetables(
    backgroundColor: Color(0xFF319904),
    value: 'Fruits & Vegetables',
    emojis: ['🍋', '🍑', '🍒', '🥭', '🍎', '🍆', '🌶️', '🍅', '🥑'],
    soundEffect: 'sounds/music-box-note-14514.mp3',
    animation: 'assets/animations/embarrassed.json',
    fontStyle: TextStyle(
      fontFamily: 'Helvetica',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  relaxed(
    backgroundColor: Color(0xFF00CED1),
    // DarkTurquoise
    value: 'Relaxed',
    emojis: ['😌', '🙂', '☺️', '😊', '😇', '🤗'],
    soundEffect: 'sounds/music-box-note-14514.mp3',
    animation: 'assets/animations/relaxed.json',
    fontStyle: TextStyle(
      fontFamily: 'Helvetica',
      fontSize: 13,
      color: Colors.black,
    ),
  ),
  hola(
    backgroundColor: Color(0xFF00CED1),
    value: 'Hola 👋',
    emojis: ['😊', '😃', '😁', '😄', '😆'],
    soundEffect: 'sounds/funny-test.m4a',
    animation: 'assets/animations/relaxed.json',
    fontStyle: TextStyle(
      fontFamily: 'Helvetica',
      fontSize: 13,
      color: Colors.black,
    ),
  );

  static MessageFeelingType fromJson(Map<String, dynamic> json) {
    return MessageFeelingType.values.firstWhere(
      (e) => e.value == json['value'],
      orElse: () => MessageFeelingType.happy,
    );
  }

  static MessageFeelingType fromQRJson(String? json) {
    return MessageFeelingType.values.firstWhere(
      (e) => e.value == json,
      orElse: () => MessageFeelingType.happy,
    );
  }

  final Color backgroundColor;
  final String value;
  final List<String> emojis;
  final String soundEffect;
  final String animation;
  final TextStyle fontStyle;

  const MessageFeelingType({
    required this.backgroundColor,
    required this.value,
    required this.emojis,
    required this.soundEffect,
    required this.animation,
    required this.fontStyle,
  });
}
