// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncConfigCollection on Isar {
  IsarCollection<SyncConfig> get syncConfigs => this.collection();
}

const SyncConfigSchema = CollectionSchema(
  name: r'SyncConfig',
  id: -5666375423996468429,
  properties: {
    r'fileName': PropertySchema(
      id: 0,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'lastSyncedVersion': PropertySchema(
      id: 1,
      name: r'lastSyncedVersion',
      type: IsarType.long,
    )
  },
  estimateSize: _syncConfigEstimateSize,
  serialize: _syncConfigSerialize,
  deserialize: _syncConfigDeserialize,
  deserializeProp: _syncConfigDeserializeProp,
  idName: r'id',
  indexes: {
    r'fileName': IndexSchema(
      id: -6213672517780651480,
      name: r'fileName',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'fileName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _syncConfigGetId,
  getLinks: _syncConfigGetLinks,
  attach: _syncConfigAttach,
  version: '3.1.0+1',
);

int _syncConfigEstimateSize(
  SyncConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fileName.length * 3;
  return bytesCount;
}

void _syncConfigSerialize(
  SyncConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.fileName);
  writer.writeLong(offsets[1], object.lastSyncedVersion);
}

SyncConfig _syncConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncConfig();
  object.fileName = reader.readString(offsets[0]);
  object.id = id;
  object.lastSyncedVersion = reader.readLong(offsets[1]);
  return object;
}

P _syncConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _syncConfigGetId(SyncConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncConfigGetLinks(SyncConfig object) {
  return [];
}

void _syncConfigAttach(IsarCollection<dynamic> col, Id id, SyncConfig object) {
  object.id = id;
}

extension SyncConfigByIndex on IsarCollection<SyncConfig> {
  Future<SyncConfig?> getByFileName(String fileName) {
    return getByIndex(r'fileName', [fileName]);
  }

  SyncConfig? getByFileNameSync(String fileName) {
    return getByIndexSync(r'fileName', [fileName]);
  }

  Future<bool> deleteByFileName(String fileName) {
    return deleteByIndex(r'fileName', [fileName]);
  }

  bool deleteByFileNameSync(String fileName) {
    return deleteByIndexSync(r'fileName', [fileName]);
  }

  Future<List<SyncConfig?>> getAllByFileName(List<String> fileNameValues) {
    final values = fileNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'fileName', values);
  }

  List<SyncConfig?> getAllByFileNameSync(List<String> fileNameValues) {
    final values = fileNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'fileName', values);
  }

  Future<int> deleteAllByFileName(List<String> fileNameValues) {
    final values = fileNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'fileName', values);
  }

  int deleteAllByFileNameSync(List<String> fileNameValues) {
    final values = fileNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'fileName', values);
  }

  Future<Id> putByFileName(SyncConfig object) {
    return putByIndex(r'fileName', object);
  }

  Id putByFileNameSync(SyncConfig object, {bool saveLinks = true}) {
    return putByIndexSync(r'fileName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFileName(List<SyncConfig> objects) {
    return putAllByIndex(r'fileName', objects);
  }

  List<Id> putAllByFileNameSync(List<SyncConfig> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'fileName', objects, saveLinks: saveLinks);
  }
}

extension SyncConfigQueryWhereSort
    on QueryBuilder<SyncConfig, SyncConfig, QWhere> {
  QueryBuilder<SyncConfig, SyncConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncConfigQueryWhere
    on QueryBuilder<SyncConfig, SyncConfig, QWhereClause> {
  QueryBuilder<SyncConfig, SyncConfig, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SyncConfig, SyncConfig, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterWhereClause> idBetween(
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

  QueryBuilder<SyncConfig, SyncConfig, QAfterWhereClause> fileNameEqualTo(
      String fileName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'fileName',
        value: [fileName],
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterWhereClause> fileNameNotEqualTo(
      String fileName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fileName',
              lower: [],
              upper: [fileName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fileName',
              lower: [fileName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fileName',
              lower: [fileName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fileName',
              lower: [],
              upper: [fileName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SyncConfigQueryFilter
    on QueryBuilder<SyncConfig, SyncConfig, QFilterCondition> {
  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> fileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition>
      fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition>
      fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> fileNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> fileNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition>
      fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition>
      fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition>
      lastSyncedVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition>
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

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition>
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

  QueryBuilder<SyncConfig, SyncConfig, QAfterFilterCondition>
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
}

extension SyncConfigQueryObject
    on QueryBuilder<SyncConfig, SyncConfig, QFilterCondition> {}

extension SyncConfigQueryLinks
    on QueryBuilder<SyncConfig, SyncConfig, QFilterCondition> {}

extension SyncConfigQuerySortBy
    on QueryBuilder<SyncConfig, SyncConfig, QSortBy> {
  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy> sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy> sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy> sortByLastSyncedVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedVersion', Sort.asc);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy>
      sortByLastSyncedVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedVersion', Sort.desc);
    });
  }
}

extension SyncConfigQuerySortThenBy
    on QueryBuilder<SyncConfig, SyncConfig, QSortThenBy> {
  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy> thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy> thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy> thenByLastSyncedVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedVersion', Sort.asc);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QAfterSortBy>
      thenByLastSyncedVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedVersion', Sort.desc);
    });
  }
}

extension SyncConfigQueryWhereDistinct
    on QueryBuilder<SyncConfig, SyncConfig, QDistinct> {
  QueryBuilder<SyncConfig, SyncConfig, QDistinct> distinctByFileName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncConfig, SyncConfig, QDistinct>
      distinctByLastSyncedVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedVersion');
    });
  }
}

extension SyncConfigQueryProperty
    on QueryBuilder<SyncConfig, SyncConfig, QQueryProperty> {
  QueryBuilder<SyncConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncConfig, String, QQueryOperations> fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<SyncConfig, int, QQueryOperations> lastSyncedVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedVersion');
    });
  }
}
