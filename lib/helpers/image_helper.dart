import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

ImageProvider imageProviderFromBase64String(String base64String) {
  if(base64String.isNotEmpty) {
    final UriData data = Uri
        .parse(base64String)
        .data!;
    if (data.isBase64) {
      try {
        base64String = base64String.split(',')[1];
        Uint8List bytes = base64.decode(base64String.split('\n').join());
        ImageProvider imageProvider =
            Image
                .memory(bytes, gaplessPlayback: true)
                .image;
        return imageProvider;
      } catch (e) {
      }
    }
  }
  ImageProvider imageProvider = Image
      .asset(
      'assets/images/image_placeholder.jpg',
      gaplessPlayback: true)
      .image;
  return imageProvider;
}

// void onImageLoadError(image){
//   Image(image: CachedNetworkImageProvider(
//     image,
//   ),);
// }
// Image imageFromBase64String(MasterSearchModel base64String, double height, double width) {
//   String imageURL = base64String.resultType.toLowerCase() == 'menu'
//       ?kWebUploadUrl+'menu/'+base64String.image
//       :kWebUploadUrl + 'restaurant/' + base64String.image;
//
//   if (base64String.image.isEmpty)
//     return Image.asset('assets/images/uppai_logo.png');
//   try {
//     return Image(image: CachedNetworkImageProvider(
//       imageURL,
//     ));
//
//
//     /*Uint8List decodedImage = base64Decode(base64String.split(',')[1]);
//     return Image.memory(
//       decodedImage,
//       height: height,
//       width: width,
//       fit: BoxFit.cover,
//       gaplessPlayback: true,
//     );*/
//   } catch (e) {
//     return Image.asset('assets/images/uppai_logo.png');
//   }
// }

/*Image imageFromString(String imageString, double height, double width) {
  return Image.memory(
    base64Decode(imageString),
    height: height,
    width: width,
    fit: BoxFit.cover,
    gaplessPlayback: true,
  );
}*/
