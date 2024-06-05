class Radio {
  String radioName;
  String radioUrl;

  Radio(this.radioName, this.radioUrl);

  static List<Radio> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Radio(json as String, "https://bx.cybertv.tv:2053/station/$json")).toList();
  }
}



