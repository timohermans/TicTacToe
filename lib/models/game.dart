import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

enum Mark { None, Cross, Circle }

class GameModel extends Model {
  List<List<Mark>> currentBoard;
  Mark currentMarkToPlace = Mark.None;
  Mark winner = Mark.None;
  Offset offsetToAnimate;

  GameModel() {
    _startNewGame();
  }

  _startNewGame() {
    _createNewBoard();
    _determineNextMarkToPlaceOnBoard();
  }

  _createNewBoard() {
    var amountOfRowsAndColumns = 3;
    currentBoard = [];

    for (var rowIndex = 0; rowIndex < amountOfRowsAndColumns; rowIndex++) {
      var row = <Mark>[];
      for (var columnIndex = 0;
          columnIndex < amountOfRowsAndColumns;
          columnIndex++) {
        row.add(Mark.None);
      }
      currentBoard.add(row);
    }
  }

  void _determineNextMarkToPlaceOnBoard() {
    if (currentMarkToPlace == Mark.None) {
      currentMarkToPlace = Mark.Cross;
    } else {
      currentMarkToPlace =
          currentMarkToPlace == Mark.Circle ? Mark.Cross : Mark.Circle;
    }
  }

  void markSpace(int row, int column) {
    currentBoard[row][column] = currentMarkToPlace;
    _determineNextMarkToPlaceOnBoard();
    winner = _getWinnerMark();
    this.offsetToAnimate = offsetToAnimate;

    notifyListeners();
  }

  Mark _getWinnerMark() {
    var amountOfRowsAndColumns = 3;

    for (var rowIndex = 0; rowIndex < amountOfRowsAndColumns; rowIndex++) {
      for (var columnIndex = 0;
          columnIndex < amountOfRowsAndColumns;
          columnIndex++) {
        if (_allMarksMatchingHorizontal(rowIndex, columnIndex) ||
            _allMarksMatchingVertical(rowIndex, columnIndex) ||
            _allMarksMatchingDiagonal(rowIndex, columnIndex)) {
          return currentBoard[rowIndex][columnIndex];
        }
      }
    }

    return Mark.None;
  }

  bool _allMarksMatchingHorizontal(int rowIndex, int columnIndex) {
    if (columnIndex != 0) {
      return false;
    }

    var row = currentBoard[rowIndex];

    for (var columnIndex = 1; columnIndex < 3; columnIndex++) {
      if (currentBoard[rowIndex][columnIndex] == Mark.None) {
        return false;
      }

      if (row[columnIndex - 1] != row[columnIndex]) {
        return false;
      }
    }

    return true;
  }

  bool _allMarksMatchingVertical(int rowIndex, int columnIndex) {
    if (rowIndex != 0) {
      return false;
    }

    for (var rowIndex = 1; rowIndex < 3; rowIndex++) {
      if (currentBoard[rowIndex][columnIndex] == Mark.None) {
        return false;
      }

      if (currentBoard[rowIndex - 1][columnIndex] !=
          currentBoard[rowIndex][columnIndex]) {
        return false;
      }
    }

    return true;
  }

  bool _allMarksMatchingDiagonal(int rowIndex, int columnIndex) {
    if (columnIndex == 0 && rowIndex == 0) {
      for (var index = 1; index < 3; index++) {
        if (currentBoard[rowIndex][columnIndex] == Mark.None) {
          return false;
        }

        if (currentBoard[index - 1][index - 1] != currentBoard[index][index]) {
          return false;
        }
      }

      return true;
    } else if (columnIndex == 0 && rowIndex == 2) {
      for (var rowIndex = 1; rowIndex >= 0; rowIndex--) {
        if (currentBoard[rowIndex][columnIndex] == Mark.None) {
          break;
        }

        for (var columnIndex = 1; columnIndex < 3; columnIndex++) {
          if (currentBoard[rowIndex + 1][columnIndex - 1] !=
              currentBoard[rowIndex][columnIndex]) {
            return false;
          }
        }
      }

      return true;
    } else {
      return false;
    }
  }

  IconData getMarkIconDataBy(int row, int column) {
    var mark = currentBoard[row][column];

    return determineIconDataBy(mark);
  }

  IconData getMarkIconDataByCurrentMarkToPlace() {
    var mark = currentMarkToPlace;

    return determineIconDataBy(mark);
  }

  IconData determineIconDataBy(Mark mark) {
    if (mark == Mark.Circle) {
      return Icons.radio_button_unchecked;
    } else if (mark == Mark.Cross) {
      return Icons.close;
    }
    return null;
  }
}
