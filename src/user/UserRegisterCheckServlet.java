package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserRegisterCheckServlet")
public class UserRegisterCheckServlet extends HttpServlet {
	 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 request.setCharacterEncoding("UTF-8");
		 response.setContentType("text/html;charset=UTF-8");
		 
		 String userID = request.getParameter("userID");
		 
		 if(userID==null || userID.equals("")) response.getWriter().write("-1");
		 
		 response.getWriter().write(new UserDAO().registerCheck(userID.trim()) + ""); 
		 // 공백문자열("")을 더하면서 문자열로 사용할 수 있게 됨. 
		 
		 
		 
	}

}
