package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.repository.ReviewRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Review;

@Service
public class ReviewService {

	@Autowired
	private ReviewRepository reviewRepository;

	public ReviewService(ReviewRepository reviewRepository) {
		this.reviewRepository = reviewRepository;
	}

	@Transactional
	public ResultData writeReview(int memberId, int concertId, String title, String body, int rating, String type, Integer orderId) {

	    // 1. 기존 리포지토리 메서드 활용 (파라미터만 추가)
	    reviewRepository.writeReview(memberId, concertId, title, body, rating, type, orderId);
	    int id = reviewRepository.getLastInsertId();

	    if ("REVIEW".equals(type)) {
	        reviewRepository.updateConcertRating(concertId, rating);
	    }

	    return ResultData.from("S-1", Ut.f("%d번 게시물이 등록되었습니다.", id), "id", id);
	}

	public ResultData userCanModify(int loginedMemberId, Review review) {
		if (review.getMemberId() != loginedMemberId) {
			return ResultData.from("F-A2", Ut.f("%d번 게시글에 대한 수정 권한없음", review.getId()));
		}
		return ResultData.from("S-1", Ut.f("%d번 게시글을 수정 가능", review.getId()));
	}

	public ResultData userCanDelete(int loginedMemberId, Review review) {
		if (review.getMemberId() != loginedMemberId) {
			return ResultData.from("F-A2", Ut.f("%d번 게시글에 대한 삭제 권한없음", review.getId()));
		}
		return ResultData.from("S-1", Ut.f("%d번 게시글을 삭제 가능", review.getId()));
	}
	@Transactional
	public void deleteReview(int id) {
		Review review = reviewRepository.getReviewById(id);
	    
	    reviewRepository.deleteReview(id);
	    
	    if (review != null && "REVIEW".equals(review.getType())) {
	    	 reviewRepository.updateConcertRatingStats(review.getConcertId());
	    }
	}

	public Review getForPrintReview(int loginedMemberId, int id) {
		Review review = reviewRepository.getForPrintReview(id);

		controlForPrintData(loginedMemberId, review);

		return review;
	}

	public List<Review> getReviewsByType(int concertId, String type) {
	    return reviewRepository.getReviewsByType(concertId, type);
	}

	private void controlForPrintData(int loginedMemberId, Review review) {
		if (review == null) {
			return;
		}

		ResultData userCanModifyRd = userCanModify(loginedMemberId, review);
		review.setExtra__canModify(userCanModifyRd.isSuccess());

		ResultData userCanDeleteRd = userCanDelete(loginedMemberId, review);
		review.setExtra__canDelete(userCanDeleteRd.isSuccess());
	}
	
	@Transactional
	public void modifyReview(int id, String title, String body, int rating) {
		Review review = reviewRepository.getReviewById(id);
		reviewRepository.modifyReview(id, title, body, rating);
		
		if ("REVIEW".equals(review.getType())) {
			reviewRepository.updateConcertRatingStats(review.getConcertId());
	    }

	}

	public Review getReviewById(int id) {
		return reviewRepository.getReviewById(id);
	}

	public List<Review> getReviews() {
		return reviewRepository.getReviews();
	}

	public List<Review> getForPrintReviewsByType(String type) {

		List<Review> reviews = reviewRepository.getForPrintReviewsByType(type);

		return reviews;
	}

}