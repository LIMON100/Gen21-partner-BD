import 'package:flutter/cupertino.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    @required this.title,
    @required this.image,
    @required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Step-1",
    image: "assets/screens/p2.jpg",
    desc: "Wait for customer Order and Accept the offer.",
  ),
  OnboardingContents(
    title: "Step-2",
    image: "assets/screens/p5.jpeg",
    desc: "You are on the way for work",
  ),
  OnboardingContents(
    title: "Step-3",
    image: "assets/screens/p6.jpeg",
    desc: "You are ready to start the work.",
  ),
  // OnboardingContents(
  //   title: "Step-4",
  //   image: "assets/screens/g8.jpg",
  //   desc: "Wait for Partner ready to work.",
  // ),
  // OnboardingContents(
  //   title: "Step-5",
  //   image: "assets/screens/g9.jpeg",
  //   desc: "Finish the job",
  // ),
  // OnboardingContents(
  //   title: "Step-6",
  //   image: "assets/screens/g10.jpeg",
  //   desc: "Give review and tips.",
  // ),
];