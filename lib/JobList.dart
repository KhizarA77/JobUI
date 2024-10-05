import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobui/jobmodel.dart';

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  Future<List<Jobmodel>> fetchJobs() async {
    final response = await http.get(Uri.parse('https://mpa0771a40ef48fcdfb7.free.beeceptor.com/jobs'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.body.codeUnits));
      final List jobsData = jsonData['data'];

      List<Jobmodel> jobs = jobsData.map((jobItem) {
        return Jobmodel.fromJson(jobItem['job']);
      }).toList();

      return jobs;
      
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jobs',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
        icon: Icon(Icons.cases_rounded),
        label: 'Jobs',
          ),
          BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_outlined),
        label: 'Resume',
          ),
          BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: const Color.fromARGB(255, 174, 0, 255),
        onTap: (index) {},
      ),
      body: FutureBuilder<List<Jobmodel>>(
        future: fetchJobs(),
        builder: (context, snap) {
          if (snap.hasData) {
            List<Jobmodel> jobs = snap.data!;
            return ListView.separated(
              itemCount: 2,
              separatorBuilder: (context, index) => const Divider(thickness: 0.5,),
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: const Color.fromARGB(255, 215, 215, 215), width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  title: Text((snap.data as List<Jobmodel>)[index].title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((snap.data as List<Jobmodel>)[index].company_name),
                      Text((snap.data as List<Jobmodel>)[index].location + ', ' + (snap.data as List<Jobmodel>)[index].workplace_type),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text((snap.data as List<Jobmodel>)[index].created_date),
                      ),
                    ],
                  ),
                  leading: Image.network( 
                    (snap.data as List<Jobmodel>)[index].logo_url,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          } else if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
