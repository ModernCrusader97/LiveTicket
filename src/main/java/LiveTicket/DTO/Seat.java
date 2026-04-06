package LiveTicket.DTO;

import java.util.Map;

public class Seat {
	private long id;
    private String rowName;
    private int colNumber;
    private String status;
    private int version;

    private String gradeName;
    private int price;

    public Seat(Map<String, Object> map) {
        this.id = Long.parseLong(String.valueOf(map.get("id")));
        this.rowName = (String) map.get("row_name");
        this.colNumber = Integer.parseInt(String.valueOf(map.get("col_number")));
        this.status = (String) map.get("status");
        this.version = Integer.parseInt(String.valueOf(map.get("version")));
        
        if (map.get("grade_name") != null) {
            this.gradeName = (String) map.get("grade_name");
            this.price = Integer.parseInt(String.valueOf(map.get("price")));
        }

    }
    
    public long getId() { return id; }
    public String getRowName() { return rowName; }
    public int getColNumber() { return colNumber; }
    public String getStatus() { return status; }
    public int getVersion() { return version; }
    public String getGradeName() { return gradeName; }
    public int getPrice() { return price; }    
}
