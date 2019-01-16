package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class UserDAO {
	//Data Access Object
	
	// ������ Ǯ ���� ��ü
	DataSource dataSource;
	
	public UserDAO(){
		try{
			// context ��ü. ���������� �ҽ��� ���� �����ϰ� ��
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/UserChat");
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// �α��� �޼ҵ�
	public int login(String userID, String userPassword){
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		String SQL = "SELECT * FROM USER WHERE userID=?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()){
				if(rs.getString("userPassword").equals(userPassword)){
					return 1;	//�α��� ����
				}
				return 2;		// ��й�ȣ Ʋ��
			}else{
				return 0;		// id ����
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			// sql connector ����
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
				if(rs!=null) rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB ����
	} 
	
	// ID �ߺ� üũ �޼ҵ�
	public int registerCheck(String userID){
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		String SQL = "SELECT * FROM USER WHERE userID=?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()|| userID.equals("")){
				return 0;		// �̹� �����ϴ� ID
			}else{
				return 1;		// ȸ������ ���� ID
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			// sql connector ����
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
				if(rs!=null) rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB ����
	}
	
	// ȸ�� ���� �޼ҵ�
	public int register(String userID, String userPassword, String userName, String userAge, String userGender, String userEmail, String userProfile ){
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO USER VALUE(?,?,?,?,?,?,?)";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, userPassword);
			pstmt.setString(3, userName);
			pstmt.setInt(4, Integer.parseInt(userAge));
			pstmt.setString(5, userGender);
			pstmt.setString(6, userEmail);
			pstmt.setString(7, userProfile);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			// sql connector ����
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB ����
	}

	public UserDTO getUser(String userID){
		
		UserDTO user = new UserDTO();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		String SQL = "SELECT * FROM USER WHERE userID=?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()){
				user.setUserID(userID);
				user.setUserPassword(rs.getString("userPassword"));
				user.setUserName(rs.getString("userName"));
				user.setUserAge(rs.getInt("userAge"));
				user.setUserGender(rs.getString("userGender"));
				user.setUserEmail(rs.getString("userEmail"));
				user.setUserProfile(rs.getString("userProfile"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
				if(rs!=null) rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return user;
	}
	public int update(String userID, String userPassword, String userName, String userAge, String userGender, String userEmail){
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE USER SET userPassword = ?, userName = ?, userAge = ?, userGender = ?, userEmail = ? WHERE userID = ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userPassword);
			pstmt.setString(2, userName);
			pstmt.setInt(3, Integer.parseInt(userAge));
			pstmt.setString(4, userGender);
			pstmt.setString(5, userEmail);
			pstmt.setString(6, userID);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			// sql connector ����
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB ����
	}
	
	public int profile(String userID, String userProfile){
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE USER SET userProfile = ? WHERE userID = ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userProfile);
			pstmt.setString(2, userID);
			
			return pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
   			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB ����
	}
public String getProfile(String userID){
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		String SQL = "SELECT userProfile FROM USER WHERE userID = ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()){
				if(rs.getString("userProfile").equals("")){
					return "http://localhost:8081/UserChat/images/icon.jpg";
				}
				return "http://localhost:8081/UserChat/upload/" + rs.getString("userProfile");  
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			// sql connector ����
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
				if(rs!=null) rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "http://localhost:8081/UserChat/images/icon.jpg";
	}
}
