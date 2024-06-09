import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import styled from 'styled-components';
import {
  GlobalStyle,
  PageContainer,
  MainContent,
  ContentWrapper,
  SubHeader,
  SubTitle,
} from '../../styles/commonStyles';
import { Category } from '../../components/Category';
import { getPostByIdApi, putPostApi } from '../../api/PostApi'; // API 함수 가져오기

const PostEditPage = () => {
  const { postId } = useParams(); // URL 파라미터에서 글 ID를 가져옴
  const [category, setCategory] = useState('');
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [images, setImages] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    const loadPost = async () => {
      try {
        const data = await getPostByIdApi(postId);
        setCategory(data.categoryId);
        setTitle(data.title);
        setContent(data.content);
        setImages(data.postImageUrls);
      } catch (error) {
        console.error('Failed to load post:', error);
      }
    };

    loadPost();
  }, [postId]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const updateData = {
        categoryId: category,
        title,
        content,
        postImageUrls: images,
      };
      await putPostApi(postId, updateData);
      navigate(`/post/${postId}`);
    } catch (error) {
      console.error('Failed to update post:', error);
    }
  };

  const handleImageChange = (e) => {
    if (e.target.files) {
      const fileArray = Array.from(e.target.files).map((file) => URL.createObjectURL(file));
      setImages((prevImages) => prevImages.concat(fileArray));
      Array.from(e.target.files).map((file) => URL.revokeObjectURL(file));
    }
  };

  const renderPhotos = (source) => {
    return source.map((photo) => {
      return <ImagePreview key={photo} src={photo} alt="" />;
    });
  };

  return (
    <>
      <GlobalStyle />
      <PageContainer>
        <MainContent>
          <ContentWrapper>
            <SubHeader>
              <SubTitle>✏️ 글 수정</SubTitle>
            </SubHeader>
            <Form onSubmit={handleSubmit}>
              <FormItem>
                <Label>카테고리</Label>
                <Select value={category} onChange={(e) => setCategory(e.target.value)} required>
                  <option value="" disabled>카테고리를 선택하세요</option>
                  {Object.values(Category).map((cat) => (
                    <option key={cat.id} value={cat.id}>
                      {cat.name}
                    </option>
                  ))}
                </Select>
              </FormItem>
              <FormItem>
                <Label>제목</Label>
                <Input type="text" value={title} onChange={(e) => setTitle(e.target.value)} required />
              </FormItem>
              <FormItem>
                <Label>내용</Label>
                <Textarea value={content} onChange={(e) => setContent(e.target.value)} required />
              </FormItem>
              <FormItem>
                <Label>사진 업로드</Label>
                <Input type="file" accept="image/*" multiple onChange={handleImageChange} />
                <ImagePreviewContainer>{renderPhotos(images)}</ImagePreviewContainer>
              </FormItem>
              <Button type="submit">게시글 수정</Button>
            </Form>
          </ContentWrapper>
        </MainContent>
      </PageContainer>
    </>
  );
};

export default PostEditPage;

// 스타일드 컴포넌트
const Form = styled.form`
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
`;

const FormItem = styled.div`
  display: flex;
  flex-direction: column;
  margin-bottom: 15px;
`;

const Label = styled.label`
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
`;

const Input = styled.input`
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  background-color: #fff;
  color: #333;
`;

const Textarea = styled.textarea`
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  background-color: #fff;
  color: #333;
  resize: vertical;
  min-height: 150px;
`;

const Select = styled.select`
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  background-color: #fff;
  color: #333;
`;

const Button = styled.button`
  padding: 10px 20px;
  background-color: #ffca28;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  margin-top: 10px;

  &:hover {
    background-color: #ffb300;
  }
`;

const ImagePreviewContainer = styled.div`
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 10px;
`;

const ImagePreview = styled.img`
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 4px;
`;
