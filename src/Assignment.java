public class Assignment {
    public String name;
    public int deadLineDays;
    public boolean isActive=true;

    public Assignment(String name, int deadLineDays) {
        this.name = name;
        this.deadLineDays = deadLineDays;
    }

    public void changeDeadLine(int newDays){
        deadLineDays=newDays;
        if (newDays<=0)
            isActive=false;
        if (isActive==false && newDays>0)
            isActive=true;
    }
}
