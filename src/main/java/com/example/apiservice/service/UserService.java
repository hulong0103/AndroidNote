package com.example.apiservice.service;

import com.example.apiservice.dto.UserRequest;
import com.example.apiservice.model.User;
import com.example.apiservice.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    // 创建用户
    public User createUser(UserRequest userRequest) {
        // 检查用户名是否已存在
        if (userRepository.existsByUsername(userRequest.getUsername())) {
            throw new RuntimeException("用户名已存在: " + userRequest.getUsername());
        }
        
        // 检查邮箱是否已存在
        if (userRepository.existsByEmail(userRequest.getEmail())) {
            throw new RuntimeException("邮箱已存在: " + userRequest.getEmail());
        }
        
        User user = new User();
        user.setUsername(userRequest.getUsername());
        user.setEmail(userRequest.getEmail());
        user.setFullName(userRequest.getFullName());
        user.setPhone(userRequest.getPhone());
        user.setAddress(userRequest.getAddress());
        
        return userRepository.save(user);
    }
    
    // 根据ID获取用户
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }
    
    // 获取所有用户
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    // 根据用户名获取用户
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }
    
    // 根据邮箱获取用户
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    // 根据姓名模糊查询用户
    public List<User> searchUsersByName(String name) {
        return userRepository.findByFullNameContaining(name);
    }
    
    // 更新用户
    public User updateUser(Long id, UserRequest userRequest) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("用户不存在，ID: " + id));
        
        // 检查用户名是否被其他用户使用
        if (!user.getUsername().equals(userRequest.getUsername()) && 
            userRepository.existsByUsername(userRequest.getUsername())) {
            throw new RuntimeException("用户名已存在: " + userRequest.getUsername());
        }
        
        // 检查邮箱是否被其他用户使用
        if (!user.getEmail().equals(userRequest.getEmail()) && 
            userRepository.existsByEmail(userRequest.getEmail())) {
            throw new RuntimeException("邮箱已存在: " + userRequest.getEmail());
        }
        
        user.setUsername(userRequest.getUsername());
        user.setEmail(userRequest.getEmail());
        user.setFullName(userRequest.getFullName());
        user.setPhone(userRequest.getPhone());
        user.setAddress(userRequest.getAddress());
        
        return userRepository.save(user);
    }
    
    // 删除用户
    public void deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            throw new RuntimeException("用户不存在，ID: " + id);
        }
        userRepository.deleteById(id);
    }
    
    // 检查用户是否存在
    public boolean userExists(Long id) {
        return userRepository.existsById(id);
    }
}