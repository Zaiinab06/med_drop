import 'package:med_drop/features/catalog/data/models/medicine_model.dart';
import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';

/// Data transfer object serializing [CartItemEntity] to and from JSON.
class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.medicine,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      medicine: MedicineModel.fromJson(json['medicine'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine': (medicine is MedicineModel)
          ? (medicine as MedicineModel).toJson()
          : MedicineModel(
              id: medicine.id,
              brandName: medicine.brandName,
              saltName: medicine.saltName,
              dosageForm: medicine.dosageForm,
              strength: medicine.strength,
              unitPrice: medicine.unitPrice,
              stockCount: medicine.stockCount,
              requiresPrescription: medicine.requiresPrescription,
              imageUrl: medicine.imageUrl,
            ).toJson(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      medicine: entity.medicine,
      quantity: entity.quantity,
    );
  }
}
