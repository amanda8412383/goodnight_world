DROP database test;
create database test;
use test;
show tables;
/*  quiz_content TEXT NOT NULL,
 on delete cascade on update cascade*/
CREATE TABLE teacher_list
(
  teacher_email VARCHAR(50) NOT NULL,
  subject VARCHAR(50),
  teacher_name VARCHAR(50) NOT NULL,
  t_passward VARCHAR(50) NOT NULL,
  PRIMARY KEY (teacher_email)
);

CREATE TABLE class_list
(
  class_name VARCHAR(50),
  class_code VARCHAR(50) NOT NULL,
  teacher_email VARCHAR(50) NOT NULL,
  PRIMARY KEY (class_code),
  FOREIGN KEY (teacher_email) REFERENCES teacher_list(teacher_email) on delete cascade on update cascade
);

CREATE TABLE student_list
(
  student_name VARCHAR(50) NOT NULL,
  student_email VARCHAR(50) NOT NULL,
  s_password VARCHAR(50) NOT NULL,
  PRIMARY KEY (student_email)
);

CREATE TABLE studentgroup
(
  group_num INT NOT NULL,
  grouping_for VARCHAR(50) NOT NULL,
  class_code VARCHAR(50) NOT NULL,
  student_email VARCHAR(50) NOT NULL,
  PRIMARY KEY (group_num, class_code, student_email),
  FOREIGN KEY (class_code) REFERENCES class_list(class_code) on delete cascade on update cascade,
  FOREIGN KEY (student_email) REFERENCES student_list(student_email) on delete cascade on update cascade
);


CREATE TABLE drawing
(
  ans_grade INT,
  drawing_name VARCHAR(50) NOT NULL,
  date DATE NOT NULL,
  class_code VARCHAR(50) NOT NULL,
  PRIMARY KEY (date, class_code),
  FOREIGN KEY (class_code) REFERENCES class_list(class_code) on delete cascade on update cascade
);

CREATE TABLE test_paper
(
  test_paper_name VARCHAR(50) NOT NULL,
  test_paper_id VARCHAR(50) NOT NULL,
  teacher_email VARCHAR(50) NOT NULL,
  PRIMARY KEY (test_paper_id),
  FOREIGN KEY (teacher_email) REFERENCES teacher_list(teacher_email) on delete cascade on update cascade
);
CREATE TABLE announcement
(
  content VARCHAR(255) NOT NULL,
  date DATE NOT NULL,
  class_code VARCHAR(50) NOT NULL,
  PRIMARY KEY (class_code, date),
  FOREIGN KEY (class_code) REFERENCES class_list(class_code) on delete cascade on update cascade
);

CREATE TABLE test_paper_answer
(
  content_order INT NOT NULL,
  answers VARCHAR(255) NOT NULL,
  quiz_content text NOT NULL,
  test_paper_id VARCHAR(50) NOT NULL,
  PRIMARY KEY (content_order, test_paper_id),
  FOREIGN KEY (test_paper_id) REFERENCES test_paper(test_paper_id) on delete cascade on update cascade
);

CREATE TABLE c_s_belonging
(
  class_code VARCHAR(50) NOT NULL,
  student_email VARCHAR(50) NOT NULL,
  PRIMARY KEY (class_code, student_email),
  FOREIGN KEY (class_code) REFERENCES class_list(class_code) on delete cascade on update cascade,
  FOREIGN KEY (student_email) REFERENCES student_list(student_email) on delete cascade on update cascade
);

CREATE TABLE test_taking
(
  student_reply VARCHAR(255) NOT NULL,
  test_date DATE NOT NULL,
  test_name VARCHAR(50) NOT NULL,
  student_email VARCHAR(50) NOT NULL,
  test_paper_id VARCHAR(50) NOT NULL,
  PRIMARY KEY (student_email, test_paper_id),
  FOREIGN KEY (student_email) REFERENCES student_list(student_email) on delete cascade on update cascade,
  FOREIGN KEY (test_paper_id) REFERENCES test_paper(test_paper_id) on delete cascade on update cascade
);

CREATE TABLE class_test_assign
(
  test_date DATE NOT NULL,
  test_name VARCHAR(50) NOT NULL,
  class_code VARCHAR(50) NOT NULL,
  test_paper_id VARCHAR(50) NOT NULL,
  PRIMARY KEY (class_code, test_paper_id),
  FOREIGN KEY (class_code) REFERENCES class_list(class_code) on delete cascade on update cascade,
  FOREIGN KEY (test_paper_id) REFERENCES test_paper(test_paper_id) on delete cascade on update cascade
);


