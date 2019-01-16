package chat;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/ChatListServlet")
public class ChatListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 한글처리
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		// request 값 변수에 저장
		String fromID = request.getParameter("fromID");
		String toID = request.getParameter("toID");
		String listType = request.getParameter("listType");
		
		// null값 체크
		if(fromID == null || fromID.equals("")||
		   toID == null || toID.equals("")||
		   listType == null ||listType.equals("")){
			response.getWriter().write("");
		}else if(listType.equals("ten")){
			response.getWriter().write(getTen(URLDecoder.decode(fromID,"UTF-8"),URLDecoder.decode(toID,"UTF-8")));
		}else{
			try {
				HttpSession session = request.getSession();
				if(!URLDecoder.decode(fromID,"UTF-8").equals((String) session.getAttribute("userID"))){
					response.getWriter().write("");
					return;
				}
				response.getWriter().write(getID(URLDecoder.decode(fromID,"UTF-8"),URLDecoder.decode(toID,"UTF-8"),listType));
			} catch (Exception e) {
				response.getWriter().write("");
			}
		}
	}
	// 최근 10개 글 가져오기 -> 100개로 수정 
	public String getTen(String fromID, String toID){
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":["); // JSON(제이슨) 형태 사용 - 어떤 개발 언어라도 호환(배열등..)될 수 있는 약속.
		ChatDAO chatDAO = new ChatDAO();
		ArrayList<ChatDTO> chatList = chatDAO.getChatListRecent(fromID, toID, 100);
		
		if(chatList.size()==0) return "";
		
		for(int i =0; i< chatList.size(); i++){
			result.append("[{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"}]");
			if(i != chatList.size()-1) result.append(",");
		}
		result.append("], \"last\":\""+ chatList.get(chatList.size()-1).getChatID() + "\"}");
		
		chatDAO.readChat(fromID, toID);
		return result.toString();
	}
	
	
	public String getID(String fromID, String toID, String chatID){
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":["); // JSON (제이슨) 형태 사용 - 어떠한 언어라도 호환될 수 있는 약속.
		ChatDAO chatDAO = new ChatDAO();
		ArrayList<ChatDTO> chatList = chatDAO.getChatListByID(fromID, toID, chatID);
		if(chatList.size()==0) return "";
		for(int i =0; i< chatList.size(); i++){
			result.append("[{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"}]");
			if(i != chatList.size()-1) result.append(",");
		}
		result.append("], \"last\":\""+ chatList.get(chatList.size()-1).getChatID() + "\"}");
		chatDAO.readChat(fromID, toID);
		return result.toString();
	}

}
