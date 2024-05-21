import org.junit.*;
import static org.junit.Assert.*;

public class TestApp {
    public static Student s1;
    public static Student s2;
    public static Student s3;
    public static Teacher t1;
    public static Course c1;
    public static Course c2;
    public static Assignment as1;
    @Before
    public void setup(){
         s1=new Student("Rouzbeh",1);
         s2=new Student("Ali", 2);
         s3=new Student("Reza", 3);
        t1=new Teacher("Dr. Aliakbary");
         c1=new Course("Fizik",1);
         c2=new Course("AP",2);
         as1=new Assignment("First Assignment",10);

    }
    @Test
    public void test1(){
        t1.addCourse(c1);
        assertTrue(t1.courses.contains(c1));
        t1.removeCourse(c1);
        assertFalse(t1.courses.contains(c1));
        t1.addCourse(c2);
        t1.addStudent(c1, s1);
        assertFalse(c1.students.keySet().contains(s1));
        t1.addStudent(c2,s1);
        assertTrue(c2.students.keySet().contains(s1));
        t1.addStudent(c2,s2);
        t1.addStudent(c2,s3);
        t1.setScore(c2,s1,16);
        t1.setScore(c2,s2,19.5);
        t1.setScore(c2,s3,12);
        assertEquals(Double.valueOf(16),s1.scores.get(c2));
        assertEquals(Double.valueOf(19.5),s2.scores.get(c2));
        assertEquals(Double.valueOf(12),s3.scores.get(c2));
        assertEquals(Double.valueOf(19.5),c2.topScore());
        t1.addAssignment(c1,as1);
        t1.addAssignment(c2,as1);
        assertFalse(c1.assignments.contains(as1));
        assertTrue(c2.assignments.contains(as1));
        t1.removeAssignment(c2,as1);
        assertFalse(c2.assignments.contains(as1));
        c2.addAssignment(as1);
        t1.changeDeadLine(c2,as1,12);
        assertEquals(12,as1.deadLineDays);
    }
    @Test
    public void test2(){
        assertFalse(t1.courses.contains(c2));
        t1.addCourse(c1);
        t1.addStudent(c1,s3);
        t1.setScore(c1,s3,12);
        assertEquals(Double.valueOf(12),s3.scores.get(c1));
    }
    @Test
    public void test3(){
        t1.addCourse(c1);
        t1.addCourse(c2);
        t1.addStudent(c1,s3);
        t1.addStudent(c2,s3);
        t1.setScore(c1,s3,12);
        t1.setScore(c2,s3,16);
        assertEquals(Double.valueOf(12),s3.scores.get(c1));
        assertEquals(Double.valueOf(16),s3.scores.get(c2));
        assertEquals(Double.valueOf(14), Double.valueOf(s3.getTotalAverage()));
    }
    @Test
    public void removeStudentTest(){
        t1.addCourse(c1);
        t1.addStudent(c1,s2);
        t1.addStudent(c2,s2);
        System.out.println(t1.courses.contains(c2));
        assertFalse(c2.students.keySet().contains(s2));
        assertTrue(c1.students.keySet().contains(s2));
        assertTrue(s2.signedCourses.contains(c1));
        t1.removeStudent(c1,s2);
        assertFalse(c1.students.keySet().contains(s2));
        assertFalse(s2.signedCourses.contains(c1));

    }
}
