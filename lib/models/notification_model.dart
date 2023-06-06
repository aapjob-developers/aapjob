class NotificationModel {
  String _id="";
  String _title="";
  String _jobid="";
  String _description="";
  String _image="";
  String _status="";
  String _createdAt="";
  String _updatedAt="";

  NotificationModel(
      {String id="",
        String title="",
        String jobid="",
        String description="",
        String image="",
        String status="",
        String createdAt="",
        String updatedAt=""}) {
    this._id = id;
    this._title = title;
    this._jobid=jobid;
    this._description = description;
    this._image = image;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  String get id => _id;
  String get title => _title;
  String get jobid => _jobid;
  String get description => _description;
  String get image => _image;
  String get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _jobid=json['job_id'];
    _description = json['description'];
    _image = json['image']!=null?json['image']:"";
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['job_id'] = this._jobid;
    data['description'] = this._description;
    data['image'] = this._image;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}


