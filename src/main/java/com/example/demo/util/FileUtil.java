package com.example.demo.util;

import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUtil {

    public static String saveFile(MultipartFile file, String uploadDir) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // 1. 프로젝트의 최상위 절대 경로를 가져옵니다.
        String projectPath = System.getProperty("user.dir");
        
        // 2. 절대경로 + 설정된 업로드 경로 결합 (예: C:\spring_work\LiveTicket\src\main\resources\static\img)
        String fullPath = projectPath + "/" + uploadDir;
        
        // 3. 해당 폴더가 있는지 검사할 File 객체 생성
        File directory = new File(fullPath);

        // ★ 핵심 로직: 폴더가 존재하지 않으면 부모 폴더까지 전부 생성합니다.
        if (!directory.exists()) {
            directory.mkdirs(); 
        }

        // 4. 고유한 파일명 생성 (UUID 사용)
        String originalFileName = file.getOriginalFilename();
        String uuid = UUID.randomUUID().toString();
        String savedFileName = uuid + "_" + originalFileName;

        // 5. 최종 파일 생성 및 저장
        File saveFile = new File(directory, savedFileName);

        try {
            file.transferTo(saveFile);
            
            // DB에 저장할 접근 경로 반환 (uploadDir이 어떻게 설정되어 있느냐에 따라 약간 다를 수 있음)
            // 보통 웹에서 접근하려면 /img/파일명 형태여야 합니다.
            return "/img/" + savedFileName; 
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}