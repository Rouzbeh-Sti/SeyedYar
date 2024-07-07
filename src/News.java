import java.util.ArrayList;
import java.util.List;

public class News {
    private String title;
    private String content;
    private String url;
    private int newsID;

    static List<News> newsList = new ArrayList<>();
    public News(String title, String content, int newsID, String url, boolean saveToFile) {
        this.title = title;
        this.content = content;
        this.newsID = newsID;
        this.url = url;
        newsList.add(this);
        if (saveToFile) {
            String output = newsID + "," + title + "," + content + "," + url;
            FileController.AddToFile(output, "src\\database\\newsList.txt");
        }
    }

    public static void deleteNews(News news) {
        newsList.remove(news);
        FileController.deleteSpecifiedIDFromFile(news.getNewsID(), "src\\database\\newsList.txt");
    }

    public int getNewsID() {
        return newsID;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getUrl() {
        return url;
    }

    public static boolean checkValidID(int newsID){
        for (News news : newsList) {
            if (news.getNewsID() == newsID)
                return true;
        }
        return false;
    }

    public static News getNewsById(int Id){
        if(checkValidID(Id)){
            for(News news : newsList){
                if(news.getNewsID() == Id){
                    return news;
                }
            }
        }
        return null;
    }
}
