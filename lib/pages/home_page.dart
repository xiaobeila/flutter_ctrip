import 'package:flutter/material.dart';
import 'package:flutter_ctrip/widget/loading_container.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_ctrip/model/common_model.dart';
import 'package:flutter_ctrip/model/grid_nav_model.dart';
import 'package:flutter_ctrip/widget/webview.dart';
import 'package:flutter_ctrip/widget/cached_image.dart';
import 'package:flutter_ctrip/util/navigator_util.dart';
import 'package:flutter_ctrip/model/home_model.dart';
import 'package:flutter_ctrip/model/sales_box_model.dart';
import 'package:flutter_ctrip/dao/home_dao.dart';
import 'package:flutter_ctrip/widget/local_nav.dart';
import 'package:flutter_ctrip/widget/grid_nav.dart';
import 'package:flutter_ctrip/widget/sub_nav.dart';
import 'package:flutter_ctrip/widget/sales_box.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool _loading = true; //页面加载状态
  double appBarAlpha = 0;
  List<CommonModel> bannerList = []; //轮播图列表
  List<CommonModel> localNavList = []; //local导航
  GridNavModel gridNav; //网格卡片
  List<CommonModel> subNavList = []; //活动导航
  SalesBoxModel salesBox; //salesBox数据

  @override
  void initState() {
    _handleRefresh();
    super.initState();
  }

  //缓存页面
  @override
  bool get wantKeepAlive => true;

  //判断滚动改变透明度
  void _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  //加载首页数据
  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        bannerList = model.bannerList;
        localNavList = model.localNavList;
        gridNav = model.gridNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: RefreshIndicator(
                      child: NotificationListener(
                        child: _listView,
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification &&
                              scrollNotification.depth == 0) {
                            //滚动并且是列表滚动的时候
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                        },
                      ),
                      onRefresh: _handleRefresh)),
              _appBar
            ],
          )),
    );
  }

  /*自定义appBar*/
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  //listView列表
  Widget get _listView {
    return ListView(
      children: <Widget>[
        /*轮播图*/
        _banner,
        /*local导航*/
        Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: LocalNav(localNavList: localNavList)),
        /*网格卡片*/
        Padding(
          padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
          child: GridNav(gridNav: gridNav),
        ),
        /*活动导航*/
        Padding(
          padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
          child: SubNav(subNavList: subNavList),
        ),
        /*底部卡片*/
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(salesBox: salesBox),
        ),
      ],
    );
  }

  /*banner轮播图*/
  Widget get _banner {
    return Container(
      height: 180,
      child: Swiper(
        autoplay: true,
        loop: true,
        pagination: SwiperPagination(),
        itemCount: bannerList.length,
        itemBuilder: (BuildContext context, int index) {
          return CachedImage(
            imageUrl: bannerList[index].icon,
            fit: BoxFit.fill,
          );
        },
        onTap: (index) {
          NavigatorUtil.push(
              context,
              WebView(
                url: bannerList[index].url,
                hideAppBar: bannerList[index].hideAppBar,
                title: bannerList[index].title,
              ));
        },
      ),
    );
  }
}
