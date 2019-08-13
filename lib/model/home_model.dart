import 'package:flutter_ctrip/model/common_model.dart';
import 'package:flutter_ctrip/model/grid_nav_model.dart';
import 'package:flutter_ctrip/model/config_model.dart';
import 'package:flutter_ctrip/model/sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final GridNavModel gridNav;
  final List<CommonModel> subNavList;
  final SalesBoxModel salesBox;

  HomeModel(
      {this.config,
      this.bannerList,
      this.localNavList,
      this.gridNav,
      this.subNavList,
      this.salesBox});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList =
        bannerListJson.map((i) => CommonModel.fromJson(i)).toList();

    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList =
        localNavListJson.map((i) => CommonModel.fromJson(i)).toList();

    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList =
        subNavListJson.map((i) => CommonModel.fromJson(i)).toList();

    return HomeModel(
      bannerList: bannerList,
      config: ConfigModel.fromJson(json['config']),
      localNavList: localNavList,
      gridNav: GridNavModel.fromJson(json['gridNav']),
      subNavList: subNavList,
      salesBox: SalesBoxModel.fromJson(json['salesBox']),
    );
  }
}
