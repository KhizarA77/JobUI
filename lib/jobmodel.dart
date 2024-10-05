class Jobmodel {

  final String title;
  final String company_name;
  final String location;
  final String jobtype;
  final String created_date;
  final String logo_url;
  final String workplace_type;

  Jobmodel({required this.title, required this.company_name, required this.location, required this.jobtype, required this.created_date, required this.logo_url, required this.workplace_type});

  factory Jobmodel.fromJson(Map<String, dynamic> json) {
    return Jobmodel(

      logo_url: json['company']['logo'],

      title: json['title'],

      company_name: json['company']['name'],
      
      location: json['location']['name_en'],
      
      jobtype: json['type']['name_en'],

      workplace_type: json['workplace_type']['name_en'],
      
      created_date: json['created_date'],
    
    );
  }



}