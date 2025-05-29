import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget profilewidget({ String? imageUrl,File? image}){
if(image==null){
  if(imageUrl==null || imageUrl==""){
    return Image.asset('assets/Png-removebg-preview.png',
    fit:BoxFit.cover,
    );
  }else{
    return CachedNetworkImage(imageUrl: imageUrl,fit:BoxFit.cover,
    progressIndicatorBuilder: (context, url, downloadProgress) {
      // return Center(child: CircularProgressIndicator(),);
      return   Center(
        child: Lottie.asset(
          'assets/animation/new Animation.json',
          width: 150,
          height: 150,
        ),
      );
    },
       errorWidget: (context, url, error) => Image.asset(
          'assets/Png-removebg-preview.png',
          fit: BoxFit.cover,
        ),
    );
  }
}else{
  return Image.file(image,fit: BoxFit.cover,);
}
}

