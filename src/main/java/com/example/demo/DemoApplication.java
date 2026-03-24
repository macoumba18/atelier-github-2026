package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@SpringBootApplication
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}

@Controller
class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        // Récupérer le profil actif depuis les variables d'environnement
        String activeProfile = System.getenv("SPRING_PROFILES_ACTIVE");
        if (activeProfile == null) {
            activeProfile = System.getProperty("spring.profiles.active", "default");
        }
        
        model.addAttribute("environment", activeProfile);
        model.addAttribute("serverPort", System.getProperty("server.port", "8080"));
        model.addAttribute("timestamp", java.time.LocalDateTime.now().toString());
        return "index";
    }
}