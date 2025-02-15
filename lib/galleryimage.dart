library galleryimage;

import 'package:flutter/material.dart';

import 'gallery_item_model.dart';
import 'gallery_item_thumbnail.dart';
import './gallery_image_view_wrapper.dart';

class GalleryImage<T extends GalleryItemModel> extends StatefulWidget {
  final List<T> galleryItems;
  final ValueChanged<T> galleryItemSelected;
  final String? titleGallery;
  final int numOfShowImages;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;
  final Color? colorOfNumberWidget;
  final Color galleryBackgroundColor;
  final TextStyle? textStyleOfNumberWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double minScale;
  final double maxScale;
  final double imageRadius;
  final bool reverse;
  final bool showListInGalley;
  final bool showAppBar;
  final bool closeWhenSwipeUp;
  final bool closeWhenSwipeDown;
  final bool showGalleryImageNameTooltip;

  const GalleryImage({
    super.key,
    required this.galleryItems,
    required this.galleryItemSelected,
    this.titleGallery,
    this.childAspectRatio = 1,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 5,
    this.crossAxisSpacing = 5,
    this.numOfShowImages = 3,
    this.colorOfNumberWidget,
    this.textStyleOfNumberWidget,
    this.padding = EdgeInsets.zero,
    this.loadingWidget,
    this.errorWidget,
    this.galleryBackgroundColor = Colors.black,
    this.minScale = .5,
    this.maxScale = 10,
    this.imageRadius = 8,
    this.reverse = false,
    this.showListInGalley = true,
    this.showAppBar = true,
    this.closeWhenSwipeUp = false,
    this.closeWhenSwipeDown = false,
    this.showGalleryImageNameTooltip = false,
  });

  @override
  State<GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  List<GalleryItemModel> galleryItems = <GalleryItemModel>[];
  int _imagesToShow = 0;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.galleryItems.length; i++) {
      widget.galleryItems[i].index = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    _imagesToShow = (widget.numOfShowImages >= widget.galleryItems.length)
        ? widget.numOfShowImages
        : widget.galleryItems.length;

    return widget.galleryItems.isEmpty
        ? const SizedBox.shrink()
        : GridView.builder(
            primary: false,
            itemCount: widget.galleryItems.length > 3
                ? _imagesToShow
                : widget.galleryItems.length,
            padding: widget.padding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: widget.childAspectRatio,
              crossAxisCount: widget.crossAxisCount,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
            ),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _isLastItem(index)
                  ? _buildImageNumbers(index)
                  : Tooltip(
                      message: widget.showGalleryImageNameTooltip
                          ? widget.galleryItems[index].name
                          : '',
                      child: GalleryItemThumbnail(
                        galleryItem: widget.galleryItems[index],
                        onTap: () {
                          widget
                              .galleryItemSelected(widget.galleryItems[index]);
                        },
                        loadingWidget: widget.loadingWidget,
                        errorWidget: widget.errorWidget,
                        radius: widget.imageRadius,
                      ),
                    );
            });
  }

// build image with number for other images
  Widget _buildImageNumbers(int index) {
    return GestureDetector(
      onTap: () {
        _openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          Tooltip(
            message: widget.showGalleryImageNameTooltip
                ? widget.galleryItems[index].name
                : '',
            child: GalleryItemThumbnail(
              galleryItem: galleryItems[index],
              loadingWidget: widget.loadingWidget,
              errorWidget: widget.errorWidget,
              onTap: null,
              radius: widget.imageRadius,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.imageRadius)),
            child: ColoredBox(
              color: widget.colorOfNumberWidget ?? Colors.black.withOpacity(.7),
              child: Center(
                child: Text(
                  "+${galleryItems.length - index}",
                  style: widget.textStyleOfNumberWidget ??
                      const TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Check if item is last image in grid to view image or number
  bool _isLastItem(int index) {
    return index < galleryItems.length - 1 &&
        index == widget.numOfShowImages - 1;
  }

// to open gallery image in full screen
  Future<void> _openImageFullScreen(int indexOfImage) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageViewWrapper(
          titleGallery: widget.titleGallery,
          galleryItems: galleryItems,
          backgroundColor: widget.galleryBackgroundColor,
          initialIndex: indexOfImage,
          loadingWidget: widget.loadingWidget,
          errorWidget: widget.errorWidget,
          maxScale: widget.maxScale,
          minScale: widget.minScale,
          reverse: widget.reverse,
          showListInGalley: widget.showListInGalley,
          showAppBar: widget.showAppBar,
          closeWhenSwipeUp: widget.closeWhenSwipeUp,
          closeWhenSwipeDown: widget.closeWhenSwipeDown,
          radius: widget.imageRadius,
        ),
      ),
    );
  }
}
