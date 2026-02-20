// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Verse {
  int get id;
  int? get topicVerseId;
  int get startVerseCode;
  int? get endVerseCode;
  String get displayRef;
  String get previewText;
  int get voteCount;
  @JsonKey(fromJson: _isFavoritedFromJson)
  bool get isFavorited;
  @JsonKey(fromJson: _myVoteFromJson)
  int? get myVote;

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerseCopyWith<Verse> get copyWith =>
      _$VerseCopyWithImpl<Verse>(this as Verse, _$identity);

  /// Serializes this Verse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Verse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicVerseId, topicVerseId) ||
                other.topicVerseId == topicVerseId) &&
            (identical(other.startVerseCode, startVerseCode) ||
                other.startVerseCode == startVerseCode) &&
            (identical(other.endVerseCode, endVerseCode) ||
                other.endVerseCode == endVerseCode) &&
            (identical(other.displayRef, displayRef) ||
                other.displayRef == displayRef) &&
            (identical(other.previewText, previewText) ||
                other.previewText == previewText) &&
            (identical(other.voteCount, voteCount) ||
                other.voteCount == voteCount) &&
            (identical(other.isFavorited, isFavorited) ||
                other.isFavorited == isFavorited) &&
            (identical(other.myVote, myVote) || other.myVote == myVote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, topicVerseId, startVerseCode,
      endVerseCode, displayRef, previewText, voteCount, isFavorited, myVote);

  @override
  String toString() {
    return 'Verse(id: $id, topicVerseId: $topicVerseId, startVerseCode: $startVerseCode, endVerseCode: $endVerseCode, displayRef: $displayRef, previewText: $previewText, voteCount: $voteCount, isFavorited: $isFavorited, myVote: $myVote)';
  }
}

/// @nodoc
abstract mixin class $VerseCopyWith<$Res> {
  factory $VerseCopyWith(Verse value, $Res Function(Verse) _then) =
      _$VerseCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int? topicVerseId,
      int startVerseCode,
      int? endVerseCode,
      String displayRef,
      String previewText,
      int voteCount,
      @JsonKey(fromJson: _isFavoritedFromJson) bool isFavorited,
      @JsonKey(fromJson: _myVoteFromJson) int? myVote});
}

/// @nodoc
class _$VerseCopyWithImpl<$Res> implements $VerseCopyWith<$Res> {
  _$VerseCopyWithImpl(this._self, this._then);

  final Verse _self;
  final $Res Function(Verse) _then;

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicVerseId = freezed,
    Object? startVerseCode = null,
    Object? endVerseCode = freezed,
    Object? displayRef = null,
    Object? previewText = null,
    Object? voteCount = null,
    Object? isFavorited = null,
    Object? myVote = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      topicVerseId: freezed == topicVerseId
          ? _self.topicVerseId
          : topicVerseId // ignore: cast_nullable_to_non_nullable
              as int?,
      startVerseCode: null == startVerseCode
          ? _self.startVerseCode
          : startVerseCode // ignore: cast_nullable_to_non_nullable
              as int,
      endVerseCode: freezed == endVerseCode
          ? _self.endVerseCode
          : endVerseCode // ignore: cast_nullable_to_non_nullable
              as int?,
      displayRef: null == displayRef
          ? _self.displayRef
          : displayRef // ignore: cast_nullable_to_non_nullable
              as String,
      previewText: null == previewText
          ? _self.previewText
          : previewText // ignore: cast_nullable_to_non_nullable
              as String,
      voteCount: null == voteCount
          ? _self.voteCount
          : voteCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFavorited: null == isFavorited
          ? _self.isFavorited
          : isFavorited // ignore: cast_nullable_to_non_nullable
              as bool,
      myVote: freezed == myVote
          ? _self.myVote
          : myVote // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Verse].
extension VersePatterns on Verse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Verse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Verse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Verse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Verse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Verse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Verse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            int? topicVerseId,
            int startVerseCode,
            int? endVerseCode,
            String displayRef,
            String previewText,
            int voteCount,
            @JsonKey(fromJson: _isFavoritedFromJson) bool isFavorited,
            @JsonKey(fromJson: _myVoteFromJson) int? myVote)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Verse() when $default != null:
        return $default(
            _that.id,
            _that.topicVerseId,
            _that.startVerseCode,
            _that.endVerseCode,
            _that.displayRef,
            _that.previewText,
            _that.voteCount,
            _that.isFavorited,
            _that.myVote);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            int? topicVerseId,
            int startVerseCode,
            int? endVerseCode,
            String displayRef,
            String previewText,
            int voteCount,
            @JsonKey(fromJson: _isFavoritedFromJson) bool isFavorited,
            @JsonKey(fromJson: _myVoteFromJson) int? myVote)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Verse():
        return $default(
            _that.id,
            _that.topicVerseId,
            _that.startVerseCode,
            _that.endVerseCode,
            _that.displayRef,
            _that.previewText,
            _that.voteCount,
            _that.isFavorited,
            _that.myVote);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            int? topicVerseId,
            int startVerseCode,
            int? endVerseCode,
            String displayRef,
            String previewText,
            int voteCount,
            @JsonKey(fromJson: _isFavoritedFromJson) bool isFavorited,
            @JsonKey(fromJson: _myVoteFromJson) int? myVote)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Verse() when $default != null:
        return $default(
            _that.id,
            _that.topicVerseId,
            _that.startVerseCode,
            _that.endVerseCode,
            _that.displayRef,
            _that.previewText,
            _that.voteCount,
            _that.isFavorited,
            _that.myVote);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Verse implements Verse {
  const _Verse(
      {required this.id,
      this.topicVerseId,
      required this.startVerseCode,
      this.endVerseCode,
      required this.displayRef,
      required this.previewText,
      required this.voteCount,
      @JsonKey(fromJson: _isFavoritedFromJson) this.isFavorited = false,
      @JsonKey(fromJson: _myVoteFromJson) this.myVote});
  factory _Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);

  @override
  final int id;
  @override
  final int? topicVerseId;
  @override
  final int startVerseCode;
  @override
  final int? endVerseCode;
  @override
  final String displayRef;
  @override
  final String previewText;
  @override
  final int voteCount;
  @override
  @JsonKey(fromJson: _isFavoritedFromJson)
  final bool isFavorited;
  @override
  @JsonKey(fromJson: _myVoteFromJson)
  final int? myVote;

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerseCopyWith<_Verse> get copyWith =>
      __$VerseCopyWithImpl<_Verse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VerseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Verse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicVerseId, topicVerseId) ||
                other.topicVerseId == topicVerseId) &&
            (identical(other.startVerseCode, startVerseCode) ||
                other.startVerseCode == startVerseCode) &&
            (identical(other.endVerseCode, endVerseCode) ||
                other.endVerseCode == endVerseCode) &&
            (identical(other.displayRef, displayRef) ||
                other.displayRef == displayRef) &&
            (identical(other.previewText, previewText) ||
                other.previewText == previewText) &&
            (identical(other.voteCount, voteCount) ||
                other.voteCount == voteCount) &&
            (identical(other.isFavorited, isFavorited) ||
                other.isFavorited == isFavorited) &&
            (identical(other.myVote, myVote) || other.myVote == myVote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, topicVerseId, startVerseCode,
      endVerseCode, displayRef, previewText, voteCount, isFavorited, myVote);

  @override
  String toString() {
    return 'Verse(id: $id, topicVerseId: $topicVerseId, startVerseCode: $startVerseCode, endVerseCode: $endVerseCode, displayRef: $displayRef, previewText: $previewText, voteCount: $voteCount, isFavorited: $isFavorited, myVote: $myVote)';
  }
}

/// @nodoc
abstract mixin class _$VerseCopyWith<$Res> implements $VerseCopyWith<$Res> {
  factory _$VerseCopyWith(_Verse value, $Res Function(_Verse) _then) =
      __$VerseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int? topicVerseId,
      int startVerseCode,
      int? endVerseCode,
      String displayRef,
      String previewText,
      int voteCount,
      @JsonKey(fromJson: _isFavoritedFromJson) bool isFavorited,
      @JsonKey(fromJson: _myVoteFromJson) int? myVote});
}

/// @nodoc
class __$VerseCopyWithImpl<$Res> implements _$VerseCopyWith<$Res> {
  __$VerseCopyWithImpl(this._self, this._then);

  final _Verse _self;
  final $Res Function(_Verse) _then;

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? topicVerseId = freezed,
    Object? startVerseCode = null,
    Object? endVerseCode = freezed,
    Object? displayRef = null,
    Object? previewText = null,
    Object? voteCount = null,
    Object? isFavorited = null,
    Object? myVote = freezed,
  }) {
    return _then(_Verse(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      topicVerseId: freezed == topicVerseId
          ? _self.topicVerseId
          : topicVerseId // ignore: cast_nullable_to_non_nullable
              as int?,
      startVerseCode: null == startVerseCode
          ? _self.startVerseCode
          : startVerseCode // ignore: cast_nullable_to_non_nullable
              as int,
      endVerseCode: freezed == endVerseCode
          ? _self.endVerseCode
          : endVerseCode // ignore: cast_nullable_to_non_nullable
              as int?,
      displayRef: null == displayRef
          ? _self.displayRef
          : displayRef // ignore: cast_nullable_to_non_nullable
              as String,
      previewText: null == previewText
          ? _self.previewText
          : previewText // ignore: cast_nullable_to_non_nullable
              as String,
      voteCount: null == voteCount
          ? _self.voteCount
          : voteCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFavorited: null == isFavorited
          ? _self.isFavorited
          : isFavorited // ignore: cast_nullable_to_non_nullable
              as bool,
      myVote: freezed == myVote
          ? _self.myVote
          : myVote // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
