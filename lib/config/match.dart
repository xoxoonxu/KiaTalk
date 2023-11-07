import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Match{
  static const String kia = 'HT';
  static const String kt = 'KT';
  static const String lotte = 'LT';
  static const String ssg = 'SK';
  static const String nc = 'NC';
  static const String lg = 'LG';
  static const String doosan = 'OB';
  static const String samsung = 'SS';
  static const String kiwoom = 'WO';
  static const String hanhwa = 'HH';

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 오늘 날짜를 "yyyyMMdd" 형식으로 가져오기
  String todayDate = DateTime.now().toString().split(' ')[0].replaceAll('-', '');
  String away = '';
  String home ='';
  String dh = '';
  Future<String> getMatchForToday() async {
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('match').where('date', isEqualTo: todayDate).get();

      String matchformat = '';
      String match='';

      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var matchDocument = querySnapshot.docs[i];

          String dhValue = matchDocument['dh'].toString();
          String awayValue = matchDocument['away'];
          String homeValue = matchDocument['home'];
          // 홈팀의 값을 변경합니다.
          if (homeValue == 'HT') {
            homeValue = 'KIA';
          } else if (homeValue == 'LT') {
            homeValue = '롯데';
          } else if (homeValue == 'SK') {
            homeValue = 'SSG';
          } else if (homeValue == 'OB') {
            homeValue = '두산';
          } else if (homeValue == 'SS') {
            homeValue = '삼성';
          } else if (homeValue == 'WO') {
            homeValue = '키움';
          } else if (homeValue == 'HH') {
            homeValue = '한화';
          }

          // 어웨이팀의 값을 변경합니다.
          if (awayValue == 'HT') {
            awayValue = 'KIA';
          } else if (awayValue == 'LT') {
            awayValue = '롯데';
          } else if (awayValue == 'SK') {
            awayValue = 'SSG';
          } else if (awayValue == 'OB') {
            awayValue = '두산';
          } else if (awayValue == 'SS') {
            awayValue = '삼성';
          } else if (awayValue == 'WO') {
            awayValue = '키움';
          } else if (awayValue == 'HH') {
            awayValue = '한화';
          }

          match='$awayValue \t vs \t $homeValue';
        }
      } else {
        match='경기 없음';
      }
      return match;
    } catch (e) {
      return 'error';
    }
  }
  Future<String> getMatchLink() async {
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('match').where('date', isEqualTo: todayDate).get();

      String matchformat = '';
      String match='';

      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var matchDocument = querySnapshot.docs[i];

          String dhValue = matchDocument['dh'].toString();
          String awayValue = matchDocument['away'];
          String homeValue = matchDocument['home'];

          matchformat = '$todayDate$awayValue$homeValue$dhValue';
        }
      } else {
        matchformat='경기 없음';
      }
      return matchformat;
    } catch (e) {
      return 'error';
    }
  }


}