package chat;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/ChatSubmitServlet")
public class ChatSubmitServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 한글처리
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		// request 값 변수에 저장
		String fromID = request.getParameter("fromID");
		String toID = request.getParameter("toID");
		String chatContent = request.getParameter("chatContent");
		
		System.out.println("chatSubmitServlet reqeust date : fromID = " + fromID + " toID = " + toID + " \n chatContent = "+ chatContent);
		
		// null값 체크
		if(fromID == null || fromID.equals("")||
				toID == null || toID.equals("")||
				chatContent == null ||chatContent.equals("")){
			response.getWriter().write("0");
		}else if(fromID.equals(toID)){
			response.getWriter().write("-1");
		}else{ 
			// 값이 있다면 UTF-8 디코딩하기
			fromID = URLDecoder.decode(fromID,"UTF-8");
			toID = URLDecoder.decode(toID,"UTF-8");
			HttpSession session = request.getSession();
			if(!URLDecoder.decode(fromID,"UTF-8").equals((String) session.getAttribute("userID"))){
				response.getWriter().write("");
				return;
			}
			chatContent = URLDecoder.decode(chatContent, "UTF-8");
			response.getWriter().write(new ChatDAO().submit(fromID, toID, chatContent ) + "");
		}
	}

}
