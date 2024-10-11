import 'dart:convert';

ProductDetailsModel productDetailsModelFromJson(String str) =>
    ProductDetailsModel.fromJson(json.decode(str));

String productDetailsModelToJson(ProductDetailsModel data) =>
    json.encode(data.toJson());

class ProductDetailsModel {
  ProductDetailsModel(
      {this.product,
      this.productUrl,
      required this.relatedProducts,
      required this.userHasItem,
      required this.ratings,
      this.avgRating,
      required this.availableAttributes,
      required this.productInventorySet,
      required this.additionalInfoStore,
      this.maximumAvailablePrice,
      required this.productColors,
      required this.productSizes,
      required this.settingText,
      this.userRatedAlready,
      required this.returnPolicy});

  Product? product;
  String? productUrl;
  List<dynamic> relatedProducts;
  dynamic userHasItem;
  List<Rating> ratings;
  int? avgRating;
  dynamic availableAttributes;
  final dynamic productInventorySet;
  Map<String, AdditionalInfoStore>? additionalInfoStore;
  num? maximumAvailablePrice;
  List<ProductColor> productColors;
  List<ProductColor> productSizes;
  List<dynamic> settingText;
  bool? userRatedAlready;
  ReturnPolicy returnPolicy;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        product: Product.fromJson(json["product"]),
        productUrl: json["product_url"],
        relatedProducts:
            List<dynamic>.from(json["related_products"].map((x) => x)),
        userHasItem: json["user_has_item"],
        ratings:
            List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
        avgRating: json["avg_rating"],
        availableAttributes: json["available_attributes"],
        productInventorySet: json["product_inventory_set"],
        additionalInfoStore: json["additional_info_store"] is List
            ? null
            : Map.from(json["additional_info_store"]).map((k, v) =>
                MapEntry<String, AdditionalInfoStore>(
                    k, AdditionalInfoStore.fromJson(v))),
        maximumAvailablePrice: json["maximum_available_price"] is String
            ? num.tryParse(json["maximum_available_price"])
            : json["maximum_available_price"],
        productColors: List<ProductColor>.from(
            json["productColors"].map((x) => ProductColor.fromJson(x))),
        productSizes: List<ProductColor>.from(
            json["productSizes"].map((x) => ProductColor.fromJson(x))),
        settingText: List<dynamic>.from(json["setting_text"].map((x) => x)),
        userRatedAlready: json["user_rated_already"],
        returnPolicy: ReturnPolicy.fromJson(json["return_policy"]),
      );

  Map<String, dynamic> toJson() => {
        "product": product?.toJson(),
        "product_url": productUrl,
        "related_products": List<dynamic>.from(relatedProducts.map((x) => x)),
        "user_has_item": userHasItem,
        "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
        "avg_rating": avgRating,
        "available_attributes": availableAttributes.toJson(),
        "product_inventory_set":
            List<dynamic>.from(productInventorySet.map((x) => x.toJson())),
        "additional_info_store": additionalInfoStore,
        "maximum_available_price": maximumAvailablePrice,
        "productColors":
            List<dynamic>.from(productColors.map((x) => x.toJson())),
        "productSizes": List<dynamic>.from(productSizes.map((x) => x.toJson())),
        "setting_text": List<dynamic>.from(settingText.map((x) => x)),
        "user_rated_already": userRatedAlready,
        "return_policy": returnPolicy.toJson(),
      };
}

class AdditionalInfoStore {
  AdditionalInfoStore({
    this.pidId,
    this.additionalPrice,
    this.stockCount,
    this.image,
  });

  int? pidId;
  num? additionalPrice;
  int? stockCount;
  String? image;

  factory AdditionalInfoStore.fromJson(Map<String, dynamic> json) =>
      AdditionalInfoStore(
        pidId: json["pid_id"],
        additionalPrice: json["additional_price"] is String
            ? num.tryParse(json["additional_price"])
            : json["additional_price"],
        stockCount: json["stock_count"] is String
            ? int.tryParse(json["stock_count"])
            : json["stock_count"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "pid_id": pidId,
        "additional_price": additionalPrice,
        "stock_count": stockCount,
        "image": image,
      };
}

class AvailableAttributes {
  AvailableAttributes({
    required this.fabric,
  });

  List<String> fabric;

  factory AvailableAttributes.fromJson(Map<String, dynamic> json) =>
      AvailableAttributes(
        fabric: List<String>.from(json["Fabric"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Fabric": List<dynamic>.from(fabric.map((x) => x)),
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.slug,
    this.summary,
    this.description,
    this.price,
    this.salePrice,
    this.cost,
    this.badgeId,
    this.brandId,
    this.statusId,
    this.productType,
    this.soldCount,
    this.minPurchase,
    this.maxPurchase,
    this.isRefundable,
    this.isInHouse,
    this.isInventoryWarnAble,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.inventoryDetailCount,
    this.reviewsAvgRating,
    this.reviewsCount,
    this.image,
    this.category,
    this.subCategory,
    required this.childCategory,
    required this.tag,
    required this.color,
    required this.sizes,
    this.campaignProduct,
    required this.inventoryDetail,
    required this.reviews,
    this.inventory,
    required this.galleryImages,
    required this.deliveryOption,
    this.taxOSR,
  });

  int? id;
  String? name;
  String? slug;
  String? summary;
  String? description;
  num? price;
  num? salePrice;
  dynamic taxOSR;
  num? cost;
  dynamic badgeId;
  dynamic brandId;
  dynamic statusId;
  dynamic productType;
  dynamic soldCount;
  int? minPurchase;
  int? maxPurchase;
  int? isRefundable;
  int? isInHouse;
  int? isInventoryWarnAble;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? inventoryDetailCount;
  String? reviewsAvgRating;
  int? reviewsCount;
  String? image;
  Category? category;
  Category? subCategory;
  List<ChildCategory> childCategory;
  List<Tag> tag;
  List<ProductColor> color;
  List<ProductColor> sizes;
  dynamic campaignProduct;
  List<InventoryDetail> inventoryDetail;
  List<Review> reviews;
  Inventory? inventory;
  List<GalleryImage> galleryImages;
  List<DeliveryOption> deliveryOption;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        taxOSR: json["tax_options_sum_rate"],
        summary: json["summary"],
        description: json["description"],
        price: json["price"] is String
            ? num.tryParse(json["price"])
            : json["price"],
        salePrice: json["sale_price"] is String
            ? num.tryParse(json["sale_price"])
            : json["sale_price"],
        cost:
            json["cost"] is String ? num.tryParse(json["cost"]) : json["cost"],
        badgeId: json["badge_id"],
        brandId: json["brand_id"],
        statusId: json["status_id"],
        productType: json["product_type"],
        soldCount: json["sold_count"],
        minPurchase: json["min_purchase"] is String
            ? num.tryParse(json["min_purchase"])?.toInt()
            : json["min_purchase"],
        maxPurchase: json["max_purchase"] is String
            ? num.tryParse(json["max_purchase"])?.toInt()
            : json["max_purchase"],
        isRefundable: json["is_refundable"] is String
            ? int.tryParse(json["is_refundable"])
            : json["is_refundable"],
        isInHouse: json["is_in_house"] is String
            ? int.tryParse(json["is_in_house"])
            : json["is_in_house"],
        isInventoryWarnAble: json["is_inventory_warn_able"] is String
            ? int.tryParse(json["is_inventory_warn_able"])
            : json["is_inventory_warn_able"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        inventoryDetailCount: json["inventory_detail_count"] is String
            ? num.tryParse(json["inventory_detail_count"])?.toInt()
            : json["inventory_detail_count"],
        reviewsAvgRating: json["reviews_avg_rating"],
        reviewsCount: json["reviews_count"] is String
            ? num.tryParse(json["reviews_count"] ?? "")?.toInt()
            : json["reviews_count"],
        image: json["image"],
        category: Category.fromJson(json["category"]),
        subCategory: Category.fromJson(json["sub_category"]),
        childCategory: List<ChildCategory>.from(
            json["child_category"].map((x) => ChildCategory.fromJson(x))),
        tag: List<Tag>.from(json["tag"].map((x) => Tag.fromJson(x))),
        color: List<ProductColor>.from(
            json["color"].map((x) => ProductColor.fromJson(x))),
        sizes: List<ProductColor>.from(
            json["sizes"].map((x) => ProductColor.fromJson(x))),
        campaignProduct: json["campaign_product"],
        inventoryDetail: List<InventoryDetail>.from(
            json["inventory_detail"].map((x) => InventoryDetail.fromJson(x))),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        inventory: json["inventory"] != null
            ? Inventory.fromJson(json["inventory"])
            : null,
        galleryImages: List<GalleryImage>.from(
            json["gallery_images"].map((x) => GalleryImage.fromJson(x))),
        deliveryOption: List<DeliveryOption>.from(
            json["delivery_option"].map((x) => DeliveryOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "summary": summary,
        "description": description,
        "price": price,
        "sale_price": salePrice,
        "cost": cost,
        "badge_id": badgeId,
        "brand_id": brandId,
        "status_id": statusId,
        "product_type": productType,
        "sold_count": soldCount,
        "min_purchase": minPurchase,
        "max_purchase": maxPurchase,
        "is_refundable": isRefundable,
        "is_in_house": isInHouse,
        "is_inventory_warn_able": isInventoryWarnAble,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "inventory_detail_count": inventoryDetailCount,
        "reviews_avg_rating": reviewsAvgRating,
        "reviews_count": reviewsCount,
        "image": image,
        "category": category?.toJson(),
        "sub_category": subCategory?.toJson(),
        "child_category":
            List<dynamic>.from(childCategory.map((x) => x.toJson())),
        "tag": List<dynamic>.from(tag.map((x) => x.toJson())),
        "color": List<dynamic>.from(color.map((x) => x.toJson())),
        "sizes": List<dynamic>.from(sizes.map((x) => x.toJson())),
        "campaign_product": campaignProduct,
        "inventory_detail":
            List<dynamic>.from(inventoryDetail.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
        "inventory": inventory?.toJson(),
        "gallery_images":
            List<dynamic>.from(galleryImages.map((x) => x.toJson())),
        "delivery_option":
            List<dynamic>.from(deliveryOption.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.categoryImage,
    this.image,
  });
  dynamic id;
  String? name;
  String? categoryImage;
  Image? image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json["name"],
        categoryImage: json["categoryImage"],
        image: json["image"] != null ? Image.fromJson(json["image"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "categoryImage": categoryImage,
        "image": image?.toJson(),
      };
}

class Image {
  Image({
    this.id,
    this.title,
    this.path,
    this.alt,
  });

  int? id;
  String? title;
  String? path;
  dynamic alt;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        title: json["title"],
        path: json["path"],
        alt: json["alt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "path": path,
        "alt": alt,
      };
}

class ChildCategory {
  ChildCategory({this.name, this.image, this.id});
  dynamic id;
  String? name;
  dynamic image;

  factory ChildCategory.fromJson(Map<String, dynamic> json) => ChildCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}

class ProductColor {
  ProductColor({
    this.id,
    this.name,
    this.colorCode,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.laravelThroughKey,
    this.sizeCode,
  });

  int? id;
  String? name;
  String? colorCode;
  String? slug;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? laravelThroughKey;
  String? sizeCode;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        id: json["id"],
        name: json["name"],
        colorCode: json['color_code'],
        slug: json["slug"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sizeCode: json['size_code'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color_code": colorCode,
        "slug": slug,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "laravel_through_key": laravelThroughKey,
        "size_code": sizeCode,
      };
}

class DeliveryOption {
  DeliveryOption({
    this.id,
    this.productId,
    this.deliveryOptionId,
  });

  int? id;
  int? productId;
  int? deliveryOptionId;

  factory DeliveryOption.fromJson(Map<String, dynamic> json) => DeliveryOption(
        id: json["id"],
        productId: json["product_id"] is String
            ? int.tryParse(json["product_id"])
            : json["product_id"],
        deliveryOptionId: json["delivery_option_id"] is String
            ? int.tryParse(json["delivery_option_id"])
            : json["delivery_option_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "delivery_option_id": deliveryOptionId,
      };
}

class GalleryImage {
  GalleryImage({
    this.userType,
    this.image,
  });

  int? userType;
  String? image;

  factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
        userType: json["user_type"] is String
            ? int.tryParse(json["user_type"])
            : json["user_type"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "user_type": userType,
        "image": image,
      };
}

class Inventory {
  Inventory({
    this.id,
    this.productId,
    this.sku,
    this.stockCount,
    this.soldCount,
  });

  int? id;
  int? productId;
  String? sku;
  int? stockCount;
  int? soldCount;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        id: json["id"],
        productId: json["product_id"],
        sku: json["sku"],
        stockCount: json["stock_count"],
        soldCount: json["sold_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "sku": sku,
        "stock_count": stockCount,
        "sold_count": soldCount,
      };
}

class InventoryDetail {
  InventoryDetail({
    this.id,
    this.productInventoryId,
    this.productId,
    this.color,
    this.size,
    this.hash,
    this.additionalPrice,
    this.addCost,
    this.image,
    this.stockCount,
    this.soldCount,
    required this.attribute,
    required this.attrImage,
    this.productColor,
    this.productSize,
  });

  int? id;
  int? productInventoryId;
  int? productId;
  String? color;
  String? size;
  String? hash;
  num? additionalPrice;
  num? addCost;
  int? image;
  int? stockCount;
  int? soldCount;
  List<Attribute> attribute;
  AttrImage? attrImage;
  ProductColor? productColor;
  ProductColor? productSize;

  factory InventoryDetail.fromJson(Map<String, dynamic> json) =>
      InventoryDetail(
        id: json["id"],
        productInventoryId: json["product_inventory_id"] is String
            ? int.tryParse(json["product_inventory_id"])
            : json["product_inventory_id"],
        productId: json["product_id"] is String
            ? int.tryParse(json["product_id"])
            : json["product_id"],
        color: json["color"],
        size: json["size"],
        hash: json["hash"],
        additionalPrice: json["additional_price"] is String
            ? num.tryParse(json["additional_price"])
            : json["additional_price"],
        addCost: json["add_cost"] is String
            ? num.tryParse(json["add_cost"])
            : json["add_cost"],
        image: json["image"],
        stockCount: json["stock_count"] is String
            ? int.tryParse(json["stock_count"])
            : json["stock_count"],
        soldCount: json["sold_count"] is String
            ? int.tryParse(json["sold_count"])
            : json["sold_count"],
        attribute: List<Attribute>.from(
            json["attribute"].map((x) => Attribute.fromJson(x))),
        attrImage: json["attr_image"] == null
            ? null
            : AttrImage.fromJson(json["attr_image"]),
        productColor: ProductColor.fromJson(json["product_color"]),
        productSize: ProductColor.fromJson(json["product_size"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_inventory_id": productInventoryId,
        "product_id": productId,
        "color": color,
        "size": size,
        "hash": hash,
        "additional_price": additionalPrice,
        "add_cost": addCost,
        "image": image,
        "stock_count": stockCount,
        "sold_count": soldCount,
        "attribute": List<dynamic>.from(attribute.map((x) => x.toJson())),
        "attr_image": attrImage?.toJson(),
        "product_color": productColor?.toJson(),
        "product_size": productSize?.toJson(),
      };
}

class ReturnPolicy {
  ReturnPolicy({
    this.id,
    this.productId,
    this.shippingReturnDescription,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? productId;
  String? shippingReturnDescription;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ReturnPolicy.fromJson(Map<String, dynamic> json) => ReturnPolicy(
        id: json["id"],
        productId: json["product_id"] is String
            ? int.tryParse(json["product_id"])
            : json["product_id"],
        shippingReturnDescription: json["shipping_return_description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "shipping_return_description": shippingReturnDescription,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class AttrImage {
  AttrImage({
    this.id,
    this.title,
    this.path,
    this.alt,
    this.size,
    this.userType,
    this.userId,
    this.dimensions,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  String? path;
  dynamic alt;
  String? size;
  int? userType;
  int? userId;
  String? dimensions;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AttrImage.fromJson(Map<String, dynamic> json) => AttrImage(
        id: json["id"],
        title: json["title"],
        path: json["path"],
        alt: json["alt"],
        size: json["size"],
        userType: json["user_type"],
        userId: json["user_id"],
        dimensions: json["dimensions"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "path": path,
        "alt": alt,
        "size": size,
        "user_type": userType,
        "user_id": userId,
        "dimensions": dimensions,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Attribute {
  Attribute({
    this.id,
    this.productId,
    this.inventoryDetailsId,
    this.attributeName,
    this.attributeValue,
  });

  int? id;
  int? productId;
  int? inventoryDetailsId;
  String? attributeName;
  String? attributeValue;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        productId: json["product_id"],
        inventoryDetailsId: json["inventory_details_id"],
        attributeName: json["attribute_name"],
        attributeValue: json["attribute_value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "inventory_details_id": inventoryDetailsId,
        "attribute_name": attributeName,
        "attribute_value": attributeValue,
      };
}

class Review {
  Review({
    this.id,
    this.productId,
    this.userId,
    this.rating,
    this.reviewText,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  int? productId;
  int? userId;
  int? rating;
  String? reviewText;
  DateTime? createdAt;
  DateTime? updatedAt;
  ReviewUser? user;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        rating: json["rating"],
        reviewText: json["review_text"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: ReviewUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "user_id": userId,
        "rating": rating,
        "review_text": reviewText,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class ReviewUser {
  ReviewUser({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String? name;
  String? image;

  factory ReviewUser.fromJson(Map<String, dynamic> json) => ReviewUser(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}

class Tag {
  Tag({
    this.id,
    this.tagName,
    this.productId,
  });

  int? id;
  String? tagName;
  int? productId;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        tagName: json["tag_name"],
        productId: json["product_id"] is String
            ? int.tryParse(json["product_id"])
            : json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag_name": tagName,
        "product_id": productId,
      };
}

class ProductInventorySet {
  ProductInventorySet({
    this.fabric,
    this.color,
    this.size,
    this.hash,
  });

  String? fabric;
  String? color;
  String? size;
  String? hash;

  factory ProductInventorySet.fromJson(Map<String, dynamic> json) =>
      ProductInventorySet(
        fabric: json["Fabric"],
        color: json["Color"],
        size: json["Size"],
        hash: json["hash"],
      );

  Map<String, dynamic> toJson() => {
        "Fabric": fabric,
        "Color": color,
        "Size": size,
        "hash": hash,
      };
}

class Rating {
  Rating({
    this.id,
    this.productId,
    this.userId,
    this.rating,
    this.reviewText,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  int? productId;
  int? userId;
  var rating;
  String? reviewText;
  DateTime? createdAt;
  DateTime? updatedAt;
  RatingUser? user;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        rating: json["rating"],
        reviewText: json["review_text"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: RatingUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "user_id": userId,
        "rating": rating,
        "review_text": reviewText,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class RatingUser {
  RatingUser({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.username,
    this.emailVerified,
    this.emailVerifyToken,
    this.mobile,
    this.company,
    this.address,
    this.city,
    this.state,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? username;
  int? emailVerified;
  String? emailVerifyToken;
  String? mobile;
  String? company;
  String? address;
  String? city;
  String? state;
  String? country;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;

  factory RatingUser.fromJson(Map<String, dynamic> json) => RatingUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        username: json["username"],
        emailVerified: json["email_verified"],
        emailVerifyToken: json["email_verify_token"],
        mobile: json["mobile"],
        company: json["company"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "username": username,
        "email_verified": emailVerified,
        "email_verify_token": emailVerifyToken,
        "mobile": mobile,
        "company": company,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "image": image,
      };
}
