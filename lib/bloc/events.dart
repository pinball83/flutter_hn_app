import 'package:equatable/equatable.dart';

abstract class NewsEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNews extends NewsEvents {}

class ReloadNews extends NewsEvents {}

//todo добавить экшены для открытия новости и сохранения/удаления
