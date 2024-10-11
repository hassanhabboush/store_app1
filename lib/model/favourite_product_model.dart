class FavouriteProductModel {
  late int productId;
  late String title;
  late String thumbnail;
  late var discountPrice;
  late var oldPrice;

  favouriteMap() {
    var mapping = <String, dynamic>{};
    mapping['productId'] = productId;
    mapping['title'] = title;
    mapping['thumbnail'] = thumbnail;
    mapping['discountPrice'] = discountPrice;
    mapping['oldPrice'] = oldPrice;
    return mapping;
  }
}
