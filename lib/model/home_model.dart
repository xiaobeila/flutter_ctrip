import 'package:flutter_ctrip/model/common_model.dart';
import 'package:flutter_ctrip/model/config_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;

  HomeModel({
    this.config,
    this.bannerList,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList =
        bannerListJson.map((i) => CommonModel.fromJson(i)).toList();

    return HomeModel(
      bannerList: bannerList,
      config: ConfigModel.fromJson(json['config']),
    );
  }
}
