package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class UserDAO {
	//Data Access Object
	
	// 데이터 풀 접속 객체
	DataSource dataSource;
	
	public UserDAO(){
		try{
			// context 객체. 실질적으로 소스에 접근 가능하게 함
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/UserChat");
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 로그인 메소드
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
					return 1;	//로그인 성공
				}
				return 2;		// 비밀번호 틀림
			}else{
				return 0;		// id 없음
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			// sql connector 해제
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
				if(rs!=null) rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB 오류
	} 
	
	// ID 중복 체크 메소드
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
				return 0;		// 이미 존재하는 ID
			}else{
				return 1;		// 회원가입 가능 ID
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			// sql connector 해제
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
				if(rs!=null) rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB 오류
	}
	
	// 회원 가입 메소드
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
			// sql connector 해제
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB 오류
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
			// sql connector 해제
			try{
				if(conn!=null) conn.close();
				if(pstmt!=null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;	// DB 오류
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
		return -1;	// DB 오류
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
			// sql connector 해제
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
