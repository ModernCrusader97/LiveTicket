package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.Review;

@Mapper
public interface ReviewRepository {

	public void modifyReview(int id, String title, String body);

	public void deleteReview(int id);

	public Review getReviewById(int id);

	public List<Review> getReviews();

	public int getLastInsertId();

	public Review getForPrintReview(int id);

	public List<Review> getReviewsByType(int concertId, String type);

	public void updateConcertRating(int concertId, int rating);

	public void writeReview(int memberId, int concertId, String title, String body, int rating, String type,
			Integer orderId);
}