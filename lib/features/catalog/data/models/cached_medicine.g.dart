// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_medicine.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedMedicineCollection on Isar {
  IsarCollection<CachedMedicine> get cachedMedicines => this.collection();
}

const CachedMedicineSchema = CollectionSchema(
  name: r'CachedMedicine',
  id: 262439473550896983,
  properties: {
    r'brandName': PropertySchema(
      id: 0,
      name: r'brandName',
      type: IsarType.string,
    ),
    r'dosageForm': PropertySchema(
      id: 1,
      name: r'dosageForm',
      type: IsarType.string,
    ),
    r'imageUrl': PropertySchema(
      id: 2,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 3,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'remoteId': PropertySchema(
      id: 4,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'requiresPrescription': PropertySchema(
      id: 5,
      name: r'requiresPrescription',
      type: IsarType.bool,
    ),
    r'saltName': PropertySchema(
      id: 6,
      name: r'saltName',
      type: IsarType.string,
    ),
    r'stockCount': PropertySchema(
      id: 7,
      name: r'stockCount',
      type: IsarType.long,
    ),
    r'strength': PropertySchema(
      id: 8,
      name: r'strength',
      type: IsarType.string,
    ),
    r'unitPrice': PropertySchema(
      id: 9,
      name: r'unitPrice',
      type: IsarType.double,
    )
  },
  estimateSize: _cachedMedicineEstimateSize,
  serialize: _cachedMedicineSerialize,
  deserialize: _cachedMedicineDeserialize,
  deserializeProp: _cachedMedicineDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'brandName': IndexSchema(
      id: 731173631508803044,
      name: r'brandName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'brandName',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'saltName': IndexSchema(
      id: 2114959266214689236,
      name: r'saltName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'saltName',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cachedMedicineGetId,
  getLinks: _cachedMedicineGetLinks,
  attach: _cachedMedicineAttach,
  version: '3.1.0+1',
);

int _cachedMedicineEstimateSize(
  CachedMedicine object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.brandName.length * 3;
  bytesCount += 3 + object.dosageForm.length * 3;
  {
    final value = object.imageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.remoteId.length * 3;
  bytesCount += 3 + object.saltName.length * 3;
  bytesCount += 3 + object.strength.length * 3;
  return bytesCount;
}

void _cachedMedicineSerialize(
  CachedMedicine object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.brandName);
  writer.writeString(offsets[1], object.dosageForm);
  writer.writeString(offsets[2], object.imageUrl);
  writer.writeDateTime(offsets[3], object.lastUpdated);
  writer.writeString(offsets[4], object.remoteId);
  writer.writeBool(offsets[5], object.requiresPrescription);
  writer.writeString(offsets[6], object.saltName);
  writer.writeLong(offsets[7], object.stockCount);
  writer.writeString(offsets[8], object.strength);
  writer.writeDouble(offsets[9], object.unitPrice);
}

CachedMedicine _cachedMedicineDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedMedicine();
  object.brandName = reader.readString(offsets[0]);
  object.dosageForm = reader.readString(offsets[1]);
  object.id = id;
  object.imageUrl = reader.readStringOrNull(offsets[2]);
  object.lastUpdated = reader.readDateTime(offsets[3]);
  object.remoteId = reader.readString(offsets[4]);
  object.requiresPrescription = reader.readBool(offsets[5]);
  object.saltName = reader.readString(offsets[6]);
  object.stockCount = reader.readLong(offsets[7]);
  object.strength = reader.readString(offsets[8]);
  object.unitPrice = reader.readDouble(offsets[9]);
  return object;
}

P _cachedMedicineDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedMedicineGetId(CachedMedicine object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cachedMedicineGetLinks(CachedMedicine object) {
  return [];
}

void _cachedMedicineAttach(
    IsarCollection<dynamic> col, Id id, CachedMedicine object) {
  object.id = id;
}

extension CachedMedicineByIndex on IsarCollection<CachedMedicine> {
  Future<CachedMedicine?> getByRemoteId(String remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  CachedMedicine? getByRemoteIdSync(String remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(String remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(String remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<CachedMedicine?>> getAllByRemoteId(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<CachedMedicine?> getAllByRemoteIdSync(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(CachedMedicine object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(CachedMedicine object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<CachedMedicine> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(List<CachedMedicine> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension CachedMedicineQueryWhereSort
    on QueryBuilder<CachedMedicine, CachedMedicine, QWhere> {
  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhere> anyBrandName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'brandName'),
      );
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhere> anySaltName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'saltName'),
      );
    });
  }
}

extension CachedMedicineQueryWhere
    on QueryBuilder<CachedMedicine, CachedMedicine, QWhereClause> {
  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      remoteIdEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      remoteIdNotEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      brandNameEqualTo(String brandName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'brandName',
        value: [brandName],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      brandNameNotEqualTo(String brandName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'brandName',
              lower: [],
              upper: [brandName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'brandName',
              lower: [brandName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'brandName',
              lower: [brandName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'brandName',
              lower: [],
              upper: [brandName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      brandNameGreaterThan(
    String brandName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'brandName',
        lower: [brandName],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      brandNameLessThan(
    String brandName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'brandName',
        lower: [],
        upper: [brandName],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      brandNameBetween(
    String lowerBrandName,
    String upperBrandName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'brandName',
        lower: [lowerBrandName],
        includeLower: includeLower,
        upper: [upperBrandName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      brandNameStartsWith(String BrandNamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'brandName',
        lower: [BrandNamePrefix],
        upper: ['$BrandNamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      brandNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'brandName',
        value: [''],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      brandNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'brandName',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'brandName',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'brandName',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'brandName',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      saltNameEqualTo(String saltName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'saltName',
        value: [saltName],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      saltNameNotEqualTo(String saltName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'saltName',
              lower: [],
              upper: [saltName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'saltName',
              lower: [saltName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'saltName',
              lower: [saltName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'saltName',
              lower: [],
              upper: [saltName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      saltNameGreaterThan(
    String saltName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'saltName',
        lower: [saltName],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      saltNameLessThan(
    String saltName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'saltName',
        lower: [],
        upper: [saltName],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      saltNameBetween(
    String lowerSaltName,
    String upperSaltName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'saltName',
        lower: [lowerSaltName],
        includeLower: includeLower,
        upper: [upperSaltName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      saltNameStartsWith(String SaltNamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'saltName',
        lower: [SaltNamePrefix],
        upper: ['$SaltNamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      saltNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'saltName',
        value: [''],
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterWhereClause>
      saltNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'saltName',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'saltName',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'saltName',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'saltName',
              upper: [''],
            ));
      }
    });
  }
}

extension CachedMedicineQueryFilter
    on QueryBuilder<CachedMedicine, CachedMedicine, QFilterCondition> {
  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'brandName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'brandName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'brandName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'brandName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'brandName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'brandName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'brandName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'brandName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'brandName',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      brandNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'brandName',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosageForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dosageForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dosageForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dosageForm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dosageForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dosageForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dosageForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dosageForm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosageForm',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      dosageFormIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dosageForm',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      requiresPrescriptionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requiresPrescription',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saltName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saltName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saltName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saltName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'saltName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'saltName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'saltName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'saltName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saltName',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      saltNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'saltName',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      stockCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stockCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      stockCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stockCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      stockCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stockCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      stockCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stockCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'strength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'strength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'strength',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'strength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'strength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'strength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'strength',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strength',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      strengthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'strength',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      unitPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      unitPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      unitPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterFilterCondition>
      unitPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unitPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension CachedMedicineQueryObject
    on QueryBuilder<CachedMedicine, CachedMedicine, QFilterCondition> {}

extension CachedMedicineQueryLinks
    on QueryBuilder<CachedMedicine, CachedMedicine, QFilterCondition> {}

extension CachedMedicineQuerySortBy
    on QueryBuilder<CachedMedicine, CachedMedicine, QSortBy> {
  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> sortByBrandName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brandName', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByBrandNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brandName', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByDosageForm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageForm', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByDosageFormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageForm', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByRequiresPrescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiresPrescription', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByRequiresPrescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiresPrescription', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> sortBySaltName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saltName', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortBySaltNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saltName', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByStockCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockCount', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByStockCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockCount', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> sortByStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strength', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByStrengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strength', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> sortByUnitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitPrice', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      sortByUnitPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitPrice', Sort.desc);
    });
  }
}

extension CachedMedicineQuerySortThenBy
    on QueryBuilder<CachedMedicine, CachedMedicine, QSortThenBy> {
  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> thenByBrandName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brandName', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByBrandNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brandName', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByDosageForm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageForm', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByDosageFormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageForm', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByRequiresPrescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiresPrescription', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByRequiresPrescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiresPrescription', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> thenBySaltName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saltName', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenBySaltNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saltName', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByStockCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockCount', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByStockCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockCount', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> thenByStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strength', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByStrengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strength', Sort.desc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy> thenByUnitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitPrice', Sort.asc);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QAfterSortBy>
      thenByUnitPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitPrice', Sort.desc);
    });
  }
}

extension CachedMedicineQueryWhereDistinct
    on QueryBuilder<CachedMedicine, CachedMedicine, QDistinct> {
  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct> distinctByBrandName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'brandName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct> distinctByDosageForm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dosageForm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct> distinctByRemoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct>
      distinctByRequiresPrescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requiresPrescription');
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct> distinctBySaltName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saltName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct>
      distinctByStockCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stockCount');
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct> distinctByStrength(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'strength', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedMedicine, CachedMedicine, QDistinct>
      distinctByUnitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitPrice');
    });
  }
}

extension CachedMedicineQueryProperty
    on QueryBuilder<CachedMedicine, CachedMedicine, QQueryProperty> {
  QueryBuilder<CachedMedicine, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CachedMedicine, String, QQueryOperations> brandNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'brandName');
    });
  }

  QueryBuilder<CachedMedicine, String, QQueryOperations> dosageFormProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dosageForm');
    });
  }

  QueryBuilder<CachedMedicine, String?, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<CachedMedicine, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<CachedMedicine, String, QQueryOperations> remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<CachedMedicine, bool, QQueryOperations>
      requiresPrescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requiresPrescription');
    });
  }

  QueryBuilder<CachedMedicine, String, QQueryOperations> saltNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saltName');
    });
  }

  QueryBuilder<CachedMedicine, int, QQueryOperations> stockCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stockCount');
    });
  }

  QueryBuilder<CachedMedicine, String, QQueryOperations> strengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strength');
    });
  }

  QueryBuilder<CachedMedicine, double, QQueryOperations> unitPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitPrice');
    });
  }
}
