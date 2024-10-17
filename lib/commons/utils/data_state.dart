import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:get/get.dart';

abstract class DataState<T> {
  final T? data;
  final AppException? exception;

  DataState({this.data, this.exception});

  bool get isLoading => this is DataStateLoading;

  bool get isSuccess => this is DataStateSuccess;

  bool get isError => this is DataStateError;

  bool get isInitial => this is DataStateInitial;

  DataStateInitial get asInitial => this as DataStateInitial;
  DataStateLoading get asLoading => this as DataStateLoading;
  DataStateSuccess get asSuccess => this as DataStateSuccess;
  DataStateError get asError => this as DataStateError;

  factory DataState.initial({T? data}) => DataStateInitial(data: data);

  factory DataState.loading({T? data}) => DataStateLoading(data: data);

  factory DataState.success({T? data}) => DataStateSuccess(data: data);

  factory DataState.error({required AppException exception}) => DataStateError(exception: exception);

  static Rx<DataState<T>> rxInitial<T>() => Rx<DataState<T>>(DataState.initial());
  static Rx<DataState<T>> rxLoading<T>() => Rx<DataState<T>>(DataState.loading());



  // When
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(AppException exception) error,
    required R Function(T data) data,
  }) {
    if (isInitial) {
      return initial();
    } else if (isLoading) {
      return loading();
    } else if (isError) {
      return error(exception!);
    } else {
      return data(this.data!);
    }
  }


}

class DataStateInitial<T> extends DataState<T> {
  DataStateInitial({super.data});
}

class DataStateLoading<T> extends DataState<T> {
  DataStateLoading({super.data});
}

class DataStateSuccess<T> extends DataState<T> {
  DataStateSuccess({required super.data});
}

class DataStateError<T> extends DataState<T> {
  DataStateError({required super.exception});
}
