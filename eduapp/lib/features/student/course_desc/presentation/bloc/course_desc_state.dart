import 'package:equatable/equatable.dart';

class CourseDescriptionState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? courseDetails;
  final bool active;
  final bool pending;
  final int progress;
  final int materialCount;
  final int subCount;
  final List<dynamic> addedMaterials;

  const CourseDescriptionState({
    this.isLoading = true,
    this.courseDetails,
    this.active = false,
    this.pending = false,
    this.progress = 0,
    this.materialCount = 0,
    this.subCount = 0,
    this.addedMaterials = const [],
  });

  CourseDescriptionState copyWith({
    bool? isLoading,
    Map<String, dynamic>? courseDetails,
    bool? active,
    bool? pending,
    int? progress,
    int? materialCount,
    int? subCount,
    List<dynamic>? addedMaterials,
  }) {
    return CourseDescriptionState(
      isLoading: isLoading ?? this.isLoading,
      courseDetails: courseDetails ?? this.courseDetails,
      active: active ?? this.active,
      pending: pending ?? this.pending,
      progress: progress ?? this.progress,
      materialCount: materialCount ?? this.materialCount,
      subCount: subCount ?? this.subCount,
      addedMaterials: addedMaterials ?? this.addedMaterials,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        courseDetails,
        active,
        pending,
        progress,
        materialCount,
        subCount,
        addedMaterials,
      ];
}
