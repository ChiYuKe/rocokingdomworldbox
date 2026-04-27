// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSkillModelCollection on Isar {
  IsarCollection<SkillModel> get skillModels => this.collection();
}

const SkillModelSchema = CollectionSchema(
  name: r'SkillModel',
  id: 3497593675566808326,
  properties: {
    r'cdRound': PropertySchema(
      id: 0,
      name: r'cdRound',
      type: IsarType.longList,
    ),
    r'contactType': PropertySchema(
      id: 1,
      name: r'contactType',
      type: IsarType.long,
    ),
    r'damPara': PropertySchema(
      id: 2,
      name: r'damPara',
      type: IsarType.longList,
    ),
    r'damageType': PropertySchema(
      id: 3,
      name: r'damageType',
      type: IsarType.long,
    ),
    r'desc': PropertySchema(
      id: 4,
      name: r'desc',
      type: IsarType.string,
    ),
    r'energyCost': PropertySchema(
      id: 5,
      name: r'energyCost',
      type: IsarType.longList,
    ),
    r'hitPara': PropertySchema(
      id: 6,
      name: r'hitPara',
      type: IsarType.long,
    ),
    r'icon': PropertySchema(
      id: 7,
      name: r'icon',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 8,
      name: r'id',
      type: IsarType.long,
    ),
    r'lastSyncedVersion': PropertySchema(
      id: 9,
      name: r'lastSyncedVersion',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 10,
      name: r'name',
      type: IsarType.string,
    ),
    r'resId': PropertySchema(
      id: 11,
      name: r'resId',
      type: IsarType.string,
    ),
    r'skillDamType': PropertySchema(
      id: 12,
      name: r'skillDamType',
      type: IsarType.long,
    ),
    r'skillFeature': PropertySchema(
      id: 13,
      name: r'skillFeature',
      type: IsarType.long,
    ),
    r'skillPriority': PropertySchema(
      id: 14,
      name: r'skillPriority',
      type: IsarType.long,
    ),
    r'targetCount': PropertySchema(
      id: 15,
      name: r'targetCount',
      type: IsarType.long,
    ),
    r'targetType': PropertySchema(
      id: 16,
      name: r'targetType',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 17,
      name: r'type',
      type: IsarType.long,
    )
  },
  estimateSize: _skillModelEstimateSize,
  serialize: _skillModelSerialize,
  deserialize: _skillModelDeserialize,
  deserializeProp: _skillModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _skillModelGetId,
  getLinks: _skillModelGetLinks,
  attach: _skillModelAttach,
  version: '3.1.0+1',
);

int _skillModelEstimateSize(
  SkillModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cdRound.length * 8;
  bytesCount += 3 + object.damPara.length * 8;
  bytesCount += 3 + object.desc.length * 3;
  bytesCount += 3 + object.energyCost.length * 8;
  bytesCount += 3 + object.icon.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.resId.length * 3;
  return bytesCount;
}

void _skillModelSerialize(
  SkillModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.cdRound);
  writer.writeLong(offsets[1], object.contactType);
  writer.writeLongList(offsets[2], object.damPara);
  writer.writeLong(offsets[3], object.damageType);
  writer.writeString(offsets[4], object.desc);
  writer.writeLongList(offsets[5], object.energyCost);
  writer.writeLong(offsets[6], object.hitPara);
  writer.writeString(offsets[7], object.icon);
  writer.writeLong(offsets[8], object.id);
  writer.writeLong(offsets[9], object.lastSyncedVersion);
  writer.writeString(offsets[10], object.name);
  writer.writeString(offsets[11], object.resId);
  writer.writeLong(offsets[12], object.skillDamType);
  writer.writeLong(offsets[13], object.skillFeature);
  writer.writeLong(offsets[14], object.skillPriority);
  writer.writeLong(offsets[15], object.targetCount);
  writer.writeLong(offsets[16], object.targetType);
  writer.writeLong(offsets[17], object.type);
}

SkillModel _skillModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SkillModel();
  object.cdRound = reader.readLongList(offsets[0]) ?? [];
  object.contactType = reader.readLong(offsets[1]);
  object.damPara = reader.readLongList(offsets[2]) ?? [];
  object.damageType = reader.readLong(offsets[3]);
  object.desc = reader.readString(offsets[4]);
  object.energyCost = reader.readLongList(offsets[5]) ?? [];
  object.hitPara = reader.readLong(offsets[6]);
  object.icon = reader.readString(offsets[7]);
  object.id = reader.readLong(offsets[8]);
  object.isarId = id;
  object.lastSyncedVersion = reader.readLong(offsets[9]);
  object.name = reader.readString(offsets[10]);
  object.resId = reader.readString(offsets[11]);
  object.skillDamType = reader.readLong(offsets[12]);
  object.skillFeature = reader.readLong(offsets[13]);
  object.skillPriority = reader.readLong(offsets[14]);
  object.targetCount = reader.readLong(offsets[15]);
  object.targetType = reader.readLong(offsets[16]);
  object.type = reader.readLong(offsets[17]);
  return object;
}

P _skillModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongList(offset) ?? []) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _skillModelGetId(SkillModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _skillModelGetLinks(SkillModel object) {
  return [];
}

void _skillModelAttach(IsarCollection<dynamic> col, Id id, SkillModel object) {
  object.isarId = id;
}

extension SkillModelByIndex on IsarCollection<SkillModel> {
  Future<SkillModel?> getById(int id) {
    return getByIndex(r'id', [id]);
  }

  SkillModel? getByIdSync(int id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(int id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(int id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<SkillModel?>> getAllById(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<SkillModel?> getAllByIdSync(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(SkillModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(SkillModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<SkillModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<SkillModel> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension SkillModelQueryWhereSort
    on QueryBuilder<SkillModel, SkillModel, QWhere> {
  QueryBuilder<SkillModel, SkillModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'id'),
      );
    });
  }
}

extension SkillModelQueryWhere
    on QueryBuilder<SkillModel, SkillModel, QWhereClause> {
  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> idNotEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [id],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [],
        upper: [id],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [lowerId],
        includeLower: includeLower,
        upper: [upperId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SkillModelQueryFilter
    on QueryBuilder<SkillModel, SkillModel, QFilterCondition> {
  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cdRound',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cdRound',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cdRound',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cdRound',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cdRound',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> cdRoundIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cdRound',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cdRound',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cdRound',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cdRound',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      cdRoundLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cdRound',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      contactTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      contactTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      contactTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      contactTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'damPara',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'damPara',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'damPara',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'damPara',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'damPara',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> damParaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'damPara',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'damPara',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'damPara',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'damPara',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damParaLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'damPara',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> damageTypeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'damageType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damageTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'damageType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      damageTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'damageType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> damageTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'damageType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'desc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'desc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'desc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'desc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'desc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'desc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'desc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'desc',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'desc',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> descIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'desc',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energyCost',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energyCost',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energyCost',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energyCost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyCost',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyCost',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyCost',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyCost',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyCost',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      energyCostLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyCost',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> hitParaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hitPara',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      hitParaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hitPara',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> hitParaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hitPara',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> hitParaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hitPara',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'icon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> idGreaterThan(
    int value, {
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

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> idLessThan(
    int value, {
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

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
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

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      lastSyncedVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      lastSyncedVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncedVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      lastSyncedVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncedVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      lastSyncedVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncedVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> resIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resId',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      resIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resId',
        value: '',
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillDamTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skillDamType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillDamTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skillDamType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillDamTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skillDamType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillDamTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skillDamType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillFeatureEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skillFeature',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillFeatureGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skillFeature',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillFeatureLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skillFeature',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillFeatureBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skillFeature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillPriorityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skillPriority',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillPriorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skillPriority',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillPriorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skillPriority',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      skillPriorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skillPriority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      targetCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      targetCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      targetCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      targetCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> targetTypeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      targetTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition>
      targetTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetType',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> targetTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> typeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> typeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> typeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterFilterCondition> typeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SkillModelQueryObject
    on QueryBuilder<SkillModel, SkillModel, QFilterCondition> {}

extension SkillModelQueryLinks
    on QueryBuilder<SkillModel, SkillModel, QFilterCondition> {}

extension SkillModelQuerySortBy
    on QueryBuilder<SkillModel, SkillModel, QSortBy> {
  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByContactType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactType', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByContactTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactType', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByDamageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'damageType', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByDamageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'damageType', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desc', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByDescDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desc', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByHitPara() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hitPara', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByHitParaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hitPara', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByLastSyncedVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedVersion', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy>
      sortByLastSyncedVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedVersion', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByResId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resId', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByResIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resId', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortBySkillDamType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillDamType', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortBySkillDamTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillDamType', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortBySkillFeature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillFeature', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortBySkillFeatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillFeature', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortBySkillPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillPriority', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortBySkillPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillPriority', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByTargetCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCount', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByTargetCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCount', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByTargetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetType', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByTargetTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetType', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SkillModelQuerySortThenBy
    on QueryBuilder<SkillModel, SkillModel, QSortThenBy> {
  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByContactType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactType', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByContactTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactType', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByDamageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'damageType', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByDamageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'damageType', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desc', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByDescDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desc', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByHitPara() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hitPara', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByHitParaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hitPara', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByLastSyncedVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedVersion', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy>
      thenByLastSyncedVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedVersion', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByResId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resId', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByResIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resId', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenBySkillDamType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillDamType', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenBySkillDamTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillDamType', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenBySkillFeature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillFeature', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenBySkillFeatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillFeature', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenBySkillPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillPriority', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenBySkillPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skillPriority', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByTargetCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCount', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByTargetCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCount', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByTargetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetType', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByTargetTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetType', Sort.desc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SkillModelQueryWhereDistinct
    on QueryBuilder<SkillModel, SkillModel, QDistinct> {
  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByCdRound() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cdRound');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByContactType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactType');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByDamPara() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'damPara');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByDamageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'damageType');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'desc', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByEnergyCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energyCost');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByHitPara() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hitPara');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByIcon(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct>
      distinctByLastSyncedVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedVersion');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByResId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctBySkillDamType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skillDamType');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctBySkillFeature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skillFeature');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctBySkillPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skillPriority');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByTargetCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetCount');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByTargetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetType');
    });
  }

  QueryBuilder<SkillModel, SkillModel, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension SkillModelQueryProperty
    on QueryBuilder<SkillModel, SkillModel, QQueryProperty> {
  QueryBuilder<SkillModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SkillModel, List<int>, QQueryOperations> cdRoundProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cdRound');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> contactTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactType');
    });
  }

  QueryBuilder<SkillModel, List<int>, QQueryOperations> damParaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'damPara');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> damageTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'damageType');
    });
  }

  QueryBuilder<SkillModel, String, QQueryOperations> descProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'desc');
    });
  }

  QueryBuilder<SkillModel, List<int>, QQueryOperations> energyCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyCost');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> hitParaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hitPara');
    });
  }

  QueryBuilder<SkillModel, String, QQueryOperations> iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> lastSyncedVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedVersion');
    });
  }

  QueryBuilder<SkillModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SkillModel, String, QQueryOperations> resIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resId');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> skillDamTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skillDamType');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> skillFeatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skillFeature');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> skillPriorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skillPriority');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> targetCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetCount');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> targetTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetType');
    });
  }

  QueryBuilder<SkillModel, int, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
