import 'package:flutter/material.dart';

void main() {
  runApp(MyPortfolio());
}

class MyPortfolio extends StatelessWidget {
  const MyPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'James Whitman | Cloud & Network Engineer',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey,
        primaryColor: Colors.tealAccent,
      ),
      home: PortfolioHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👋 Hi, I'm Mohamed Gesmalla", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
            SizedBox(height: 10),
            Text(
              "Cloud & Network Engineer | AWS & Azure Certified | Automation Enthusiast",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            Text("🚀 About Me", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              "I'm a cloud and network engineer with 7+ years of experience building secure, scalable infrastructure on AWS and Azure. "
              "I automate deployments with Terraform and Ansible, and build CI/CD pipelines to improve efficiency.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Text("📁 Projects", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ProjectCard(
              title: "Cloud Disaster Recovery on AWS & Azure",
              description: "Deployed a resilient DR solution using Route 53 and Azure Site Recovery with automated failover.",
            ),
            ProjectCard(
              title: "CI/CD Infrastructure Pipeline",
              description: "Automated Terraform deployments using Jenkins, GitHub, and Slack integration.",
            ),
            SizedBox(height: 30),
            Text("📫 Contact", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("📧 james.whitman@email.com"),
            Text("📍 Austin, TX"),
            Text("🔗 linkedin.com/in/jameswhitman"),
            Text("💻 github.com/jwhitcloud"),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;

  const ProjectCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: TextStyle(color: Colors.white70)),
      ),
    );
  }
}
