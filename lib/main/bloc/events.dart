import 'package:equatable/equatable.dart';
import 'package:flutter_hn_app/main/model/news.dart';

abstract class NewsEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNews extends NewsEvents {}

class ReloadNews extends NewsEvents {}

class AddToFavorites extends NewsEvents {
  final News news;

  AddToFavorites(this.news);
}
//todo добавить экшены для открытия новости и сохранения/удаления
